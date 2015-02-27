import qbs
import qbs.File
import qbs.TextFile

// This is a poor man's version of syncqt.pl, using line-based rules
// and simpler regular expressions.
Module {
    // Input
    property string module

    Depends { name: "cpp" }

    Rule {
        inputs: "header_sync"
        outputFileTags: "hpp"
        outputArtifacts: {
            var module = product.moduleProperty("QtHost.sync", "module");
            var basePath = project.buildDirectory + "/include/" + module + "/";

            var fileTags = ["hpp"];

            // Simply copy private headers without parsing
            if (module == "QtGui" && (input.fileName.startsWith("qplatform")
                || input.fileName.startsWith("qwindowsysteminterface"))) {
                return [{
                    filePath: basePath + project.qtVersion + "/" + module
                              + "/qpa/" + input.fileName,
                    fileTags: fileTags.concat(["hpp_qpa"])
                }];
            }

            if (input.fileName.endsWith("_p.h")) {
                return [{
                    filePath: basePath + project.qtVersion + "/" + module
                              + "/private/" + input.fileName,
                    fileTags: fileTags.concat(["hpp_private"])
                }];
            }

            // Everything else is public
            fileTags.push("hpp_public");

            var artifacts = [];

            // regular expressions used in parsing
            var reFwdDecl = /^(class|struct) +(\w+);$/;
            var reTypedefFn = /^typedef *.*\(\*(Q[^\)]*)\)\(.*\);$/;
            var reTypedef = /^typedef +(unsigned )?([^ ]*)(<[\w, ]+>)? +(Q[^ ]*);$/;
            var reQtMacro = / ?Q_[A-Z_]+/;
            var reDecl = /^(template <class [\w, ]+> )?(class|struct) +(\w+)( ?: public [\w<>, ]+)?( {)?$/;
            var reIterator = /^Q_DECLARE_.*ITERATOR\((.*)\)$/;
            var reNamespace = /^namespace \w+( {)?/; //extern "C" could go here too

            var classes = [];

            // Special cases
            switch (input.fileName) {
            case "qdebug.h":
                classes.push("QtDebug");
                break;
            case "qendian.h":
                classes.push("QtEndian");
                break;
            case "qglobal.h":
                classes.push("QtGlobal");
                break;
            case "qnumeric.h":
                classes.push("QtNumeric");
                break;
            default:
                break;
            }

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
                /*if (braceDepth < 0 && (openingBraces.length || closingBraces.length))
                    throw "At " + lineCount + ", braceDepth is " + braceDepth + " and opening/closing for the current line are "
                            + openingBraces.length + "/" + closingBraces.length;*/
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

                // grab iterators
                if (reIterator.test(line)) {
                    classes.push(line.match(reIterator)[1]);
                    line = "";
                    continue;
                }

                line = "";
            }
            file.close();

            // Special cases/known duplicates
            for (var i in classes) {
                switch (classes[i]) {
                case "QByteArrayData":
                    if (input.fileName != "qobjectdefs.h")
                        continue;
                    break;
                case "QByteArrayList":
                    if (input.fileName != "qbytearraylist.h")
                        continue;
                    break;
                case "QVariantHash":
                case "QVariantList":
                case "QVariantMap":
                    if (input.fileName != "qmetatype.h")
                        continue;
                    break;
                default:
                    break;
                }

                artifacts.push({
                    filePath: basePath + classes[i],
                    fileTags: fileTags
                });
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
            cmd.sourceCode = function() {
                for (var i in outputs.hpp) {
                    var header = outputs.hpp[i];

                    // uncomment to aid duplicate finding
                    /*if (File.exists(header.filePath)) { // Helpful for debugging duplicates
                        var file = new TextFile(header.filePath, TextFile.ReadOnly);
                        var contents = file.readAll();
                        file.close();

                        throw 'Programming error: tried to write "' + header.filePath + '" multiple times. '
                              + 'The new forwarding header is "' + input.fileName
                              + '" and the current content is "' + contents + '"';
                        return;
                    }*/

                    var file = new TextFile(header.filePath, TextFile.WriteOnly);
                    file.writeLine("#include \"" + input.filePath + "\"");
                    file.close();
                }
            };
            return cmd;
        }
    }

    Rule {
        inputs: "hpp_" + module
        multiplex: true
        Artifact {
            filePath: {
                var module = product.moduleProperty("QtHost.sync", "module");
                return project.buildDirectory + "/include/" + module + "/" + module;
            }
            fileTags: "hpp"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "creating module header " + output.fileName;
            cmd.module = product.moduleProperty("QtHost.sync", "module");
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
}
