import qbs
import qbs.FileInfo
import qbs.TextFile
import qbs.PathTools
import "QtUtils.js" as QtUtils

QtProduct {
    type: "dynamiclibrary"
    targetName: "Qt5" + name.slice(2)
    version: configure.version
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "sync" }

    Group {
        fileTagsFilter: [
            "debuginfo",
            "dynamiclibrary",
            "dynamiclibrary_copy",
            "dynamiclibrary_import",
            "dynamiclibrary_symlink",
            "prl",
            "staticlibrary",
        ]
        qbs.install: true
        qbs.installDir: "lib"
    }

    Transformer {
        Artifact {
            filePath: project.buildDirectory + "/lib/"
                      + FileInfo.baseName(PathTools.dynamicLibraryFilePath(product)) + ".prl"
            fileTags: "prl"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.targetName = PathTools.dynamicLibraryFilePath(product);
            cmd.libs = product.moduleProperty("cpp", "dynamicLibraries").join(" -l");
            if (cmd.libs.length)
                cmd.libs = "-l" + cmd.libs;
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("QMAKE_PRL_TARGET = " + targetName);
                file.writeLine("QMAKE_PRL_LIBS = " + libs);
                file.close();
            }
            return cmd;
        }
    }

    Transformer {
        Artifact {
            filePath: "qt_lib_" + product.name.slice(2).toLowerCase() + ".pri" // ### also _private
            fileTags: "pri"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.modulePrefix = "QT." + output.baseName.slice(7) + '.';
            cmd.includes = "$$QT_MODULE_INCLUDE_BASE";
            for (var i in product.includeDependencies) {
                var module = product.includeDependencies[i];
                cmd.includes += ' ' + QtUtils.includesForModule(
                            module, "$$QT_MODULE_INCLUDE_BASE",
                            product.moduleProperty("configure", "version")).join(' ');
            }
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine(modulePrefix + "name = " + product.name);
                //QT.core.depends = ###
                //QT.core.module_config = ###
                file.writeLine(modulePrefix + "includes = " + includes);
                file.writeLine(modulePrefix + "DEFINES =");
                file.writeLine(modulePrefix + "VERSION =");
                //plugin_types
                //TYPE
                //EXTENDS
                //CLASS_NAME
                file.close();
            }
            return cmd;
        }
    }

    Group {
        fileTagsFilter: "pri"
        qbs.install: true
        qbs.installDir: "mkspecs/modules"
    }
}
