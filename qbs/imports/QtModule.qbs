import qbs
import qbs.TextFile

QtLibrary {
    targetName: "Qt5" + name.slice(2)

    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "QtHost.sync" }

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary", "dynamiclibrary_import", "staticlibrary"]
        qbs.install: true
        qbs.installDir: "lib"
    }

    Transformer {
        Artifact {
            filePath: project.buildDirectory + "/lib/"
                      + product.targetName.baseName + ".prl"
            fileTags: "prl"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.targetName = product.targetName;
            cmd.libs = product.moduleProperty("cpp", "dynamicLibraries").join(" -l");
            if (cmd.libs.length)
                cmd.libs = "-l" + cmd.libs;
            cmd.sourceCode = function() {
                var file = new TextFile(output.fileName, TextFile.WriteOnly);
                file.writeLine("QT_PRL_TARGET = " + targetName);
                file.writeLine("QMAKE_PRL_LIBS = " + libs);
                file.close();
            }
            return cmd;
        }
    }

    Group {
        fileTagsFilter: "prl"
        qbs.install: true
        qbs.installDir: "lib"
    }
}
