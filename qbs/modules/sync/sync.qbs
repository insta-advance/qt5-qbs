import qbs
import qbs.File
import qbs.TextFile

// This is a poor man's version of syncqt.pl, using line-based rules
// and simpler regular expressions.
Module {
    // Input
    property string module: ""
    property string prefix: "include"
    property path profile: ""
    property var classNames: ({})
    readonly property var classFileNames: {
        var classFileNames = {};
        for (var i in classNames) {
            for (var j in classNames[i])
                classFileNames[classNames[i][j]] = i;
        }
        return classFileNames;
    }

    Depends { name: "cpp" }

    Rule {
        inputs: "header_sync"
        outputFileTags: "hpp"
        outputArtifacts: {
            var module = product.moduleProperty("sync", "module");
            var basePath = [project.buildDirectory, product.moduleProperty("sync", "prefix"), module].join("/") + "/";

            var fileTags = ["hpp"];

            // Simply copy private headers without parsing
            var version = project.version;
            if (module == "QtGui" && (input.fileName.startsWith("qplatform")
                || input.fileName.startsWith("qwindowsysteminterface"))) {
                return [{
                    filePath: basePath + version + "/" + module + "/qpa/" + input.fileName,
                    fileTags: fileTags.concat(["hpp_qpa"])
                }];
            }

            if (input.fileName.endsWith("_p.h")) {
                return [{
                    filePath: basePath + version + "/" + module + "/private/" + input.fileName,
                    fileTags: fileTags.concat(["hpp_private", "hpp_private_" + module])
                }];
            }

            // Everything else is public
            fileTags.push("hpp_public", "hpp_public_" + module);

            var artifacts = [];

            // regular expressions used in parsing
            var reFwdDecl = /^(class|struct) +(\w+);$/;
            var reTypedefFn = /^typedef *.*\(\*(Q[^\)]*)\)\(.*\);$/;
            var reTypedef = /^typedef +(unsigned )?([^ ]*)(<[\w, ]+>)? +(Q[^ ]*);$/;
            var reQtMacro = / ?Q_[A-Z_]+/;
            var reDecl = /^(template <class [\w, ]+> )?(class|struct) +(\w+)( ?: public [\w<>, ]+)?( {)?$/;
            var reIterator = /^Q_DECLARE_\w+ITERATOR\((\w+)\)$/;
            var reNamespace = /^namespace \w+( {)?/; //extern "C" could go here too

            var classes = [];

            var insideQt = false;
            var file = new TextFile(input.filePath, TextFile.ReadOnly);
            var line = "";
            var braceDepth = 0;
            var namespaceDepth = -1;
            var lineCount = 0; // for debugging
            while (!file.atEof()) {
                if (!line.length) {
                    line = file.readLine();
                    ++lineCount;
                }

                // Remove C comments ### allow starting within a line
                if (line.startsWith("/*")) {
                    while (!file.atEof()) {
                        var commentEnd = line.indexOf("*/");
                        if (commentEnd >= 0) {
                            line = line.substring(commentEnd + 2);
                            break;
                        }
                        line = file.readLine();
                        ++lineCount;
                    }
                    continue;
                }

                // remove C++ comments
                line = line.replace(/ +\/\/.*$/, '');
                if (line.length == 0)
                    continue;

                if (line.startsWith("#")) {
                    if (line == "#pragma qt_sync_stop_processing")
                        break;

                    if (/#pragma qt_class\(([^)]*)\)$/.test(line)) {
                        classes.push(line.match(/#pragma qt_class\(([^)]*)\)$/)[1]);
                        line = "";
                        continue;
                    }

                    // Drop remaining preprocessor commands
                    while (!file.atEof()) {
                        if (line.endsWith("\\")) {
                            line = file.readLine();
                            ++lineCount;
                            continue;
                        }
                        line = "";
                        break;
                    }
                    continue;
                }

                // Track brace depth
                var openingBraces = line.match(/\{/g) || [];
                var closingBraces = line.match(/\}/g) || [];
                braceDepth += openingBraces.length - closingBraces.length;
                if (braceDepth < 0)
                    throw "Error in parsing header " + input.filePath + ", line " + lineCount + ": brace depth fell below 0.";

                // We only are interested in classes inside the namespace
                if (line == "QT_BEGIN_NAMESPACE") {
                    insideQt = true;
                    line = "";
                    continue;
                }

                if (!insideQt) {
                    line = "";
                    continue;
                }

                // Ignore internal namespaces
                if (namespaceDepth >= 0 && braceDepth >= namespaceDepth) {
                    line = "";
                    continue;
                }

                if (reNamespace.test(line)) {
                    namespaceDepth = braceDepth;
                    if (!line.endsWith("{"))
                        namespaceDepth += 1;
                    line = "";
                    continue;
                } else {
                    namespaceDepth = -1;
                }

                if (line == "QT_END_NAMESPACE") {
                    insideQt = false;
                    line = "";
                    continue;
                }

                // grab iterators
                if (reIterator.test(line)) {
                    var className = "Q";
                    if (line.contains("MUTABLE"))
                        className += "Mutable";
                    className += line.match(reIterator)[1] + "Iterator";
                    classes.push(className);
                    line = "";
                    continue;
                }

                // make parsing easier by removing noise
                line = line.replace(reQtMacro, "");

                // ignore forward declarations ### decide if this is needed (that is, if is really a false positive)
                if (reFwdDecl.test(line)) {
                    line = "";
                    continue;
                }

                // accept typedefs
                if (reTypedefFn.test(line)) {
                    classes.push(line.match(reTypedefFn)[1]);
                    line = "";
                    continue;
                }

                if (reTypedef.test(line)) {
                    classes.push(line.match(reTypedef)[4]);
                    line = "";
                    continue;
                }

                // grab classes
                if (reDecl.test(line)) {
                    classes.push(line.match(reDecl)[3]);
                    line = "";
                    continue;
                }

                line = "";
            }
            file.close();

            var classFileNames = product.moduleProperty("sync", "classFileNames");
            for (var i in classes) {
                if (classes[i] in classFileNames)
                    continue; // skip explicity defined classes (and handle them below)
                artifacts.push({
                    filePath: basePath + classes[i],
                    fileTags: fileTags
                });
            }

            var classNames = product.moduleProperty("sync", "classNames");
            if (input.fileName in classNames) {
                for (var i in classNames[input.fileName]) {
                    artifacts.push({
                        filePath: basePath + classNames[input.fileName][i],
                        fileTags: fileTags
                    });
                }
            }

            // Tag for the module header
            if (classes.length)
                fileTags.push("hpp_" + module);

            artifacts.push({
                filePath: basePath + input.fileName,
                fileTags: fileTags
            });

            return artifacts;
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "syncing " + input.fileName;
            cmd.developerBuild = product.moduleProperty("configure", "private_tests");
            cmd.sourceCode = function() {
                for (var i in outputs.hpp) {
                    var header = outputs.hpp[i];

                    // uncomment to aid duplicate finding
                    /*if (File.exists(header.filePath)) {
                        var file = new TextFile(header.filePath, TextFile.ReadOnly);
                        var contents = file.readAll();
                        file.close();

                        throw 'Programming error: tried to write "' + header.filePath + '" multiple times. '
                              + 'The new forwarding header is "' + input.fileName
                              + '" and the current content is "' + contents + '"';
                        return;
                    }*/

                    if (developerBuild) {
                        var file = new TextFile(header.filePath, TextFile.WriteOnly);
                        file.writeLine("#include \"" + input.filePath + "\"");
                        file.close();
                        continue;
                    }

                    if (input.fileName == header.fileName) {
                        File.copy(input.filePath, header.filePath);
                        continue;
                    }
                    var file = new TextFile(header.filePath, TextFile.WriteOnly);
                    file.writeLine("#include \"" + input.fileName + "\"");
                    file.close();
                }
            };
            return cmd;
        }
    }

    Rule {
        inputs: "hpp_" + product.moduleProperty("sync", "module")
        multiplex: true
        Artifact {
            filePath: {
                var module = product.moduleProperty("sync", "module");
                return [project.buildDirectory, product.moduleProperty("sync", "prefix"), module, module].join("/");
            }
            fileTags: ["hpp", "hpp_public", "hpp_public_" + product.moduleProperty("sync", "module")]
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "creating module header " + output.fileName;
            cmd.module = product.moduleProperty("sync", "module");
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("#ifndef QT_" + module.toUpperCase() + "_MODULE_H");
                file.writeLine("#define QT_" + module.toUpperCase() + "_MODULE_H");

                var headers = inputs["hpp_" + module];
                for (var i in headers)
                    file.writeLine("#include \"" + headers[i].fileName + "\"");

                file.writeLine("#endif");
                file.close();
            };
            return cmd;
        }
    }

    // Helpers for parsing sync.profile... use for creating the class name hashes
    verify: {
        if (!profile)
            return;

        var syncProfile = new TextFile(profile, TextFile.ReadOnly);

        var modules = { };
        while (!syncProfile.atEof()) {
            // Module parsing
            var line = syncProfile.readLine();
            if (line.startsWith('%modules = (')) {
                line = syncProfile.readLine();
                while (!line.startsWith(');')) {
                    var matches = line.match(/"([\w\/]*)" => "([\w\/\.\$\!]*)",/);
                    if (matches)
                        modules[matches[1]] = matches[2].replace(/\$basedir/g, project.sourceDirectory);
                    line = syncProfile.readLine();
                }
            }

            // Class name parsing
            var line = syncProfile.readLine();
            if (line.startsWith('%classnames = (')) {
                line = syncProfile.readLine();
                while (!line.startsWith(');')) {
                    var matches = line.match(/"([\w\.]*)" => "([\w,]*)",/);
                    if (matches)
                        classNames[matches[1]] = matches[2].split(',');
                    line = syncProfile.readLine();
                }
            }
        }

        print("moduleNames: ({");
        for (var i in modules)
            print('"' + i + '": "' + modules[i] + '",');
        print("})");

        print("classNames: ({");
        for (var i in classNames)
            print('"' + i + '": ["' + classNames[i].join('", "') + '"],');
        print("})");

        syncProfile.close();
    }
}
