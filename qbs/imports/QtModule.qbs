import qbs
import qbs.FileInfo
import qbs.TextFile
import qbs.PathTools
import "QtUtils.js" as QtUtils

QtProduct {
    type: "dynamiclibrary"
    targetName: "Qt5" + name.slice(2)
    version: project.version
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
            filePath: "qt_lib_" + product.name.slice(2).toLowerCase() + ".pri"
            fileTags: "pri"
        }
        Artifact {
            filePath: "qt_lib_" + product.name.slice(2).toLowerCase() + "_private.pri"
            fileTags: "pri"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating module pri for " + product.name;
            cmd.depends = ""; // ### fixme
            cmd.defines = product.moduleProperty("cpp", "defines").join(' ');
            cmd.version = project.version;
            cmd.versionParts = project.version.split('.');
            cmd.sourceCode = function() {
                for (var o in outputs.pri) {
                    var output = outputs.pri[o];
                    var isPublic = !output.baseName.endsWith("_private");
                    var modulePrefix = "QT." + output.fileName.slice(7, isPublic ? -4 : -12) + '.';
                    var includes = "$$QT_MODULE_INCLUDE_BASE";
                    for (var i in product.includeDependencies) {
                        var module = product.includeDependencies[i];
                        if (isPublic && module.endsWith("-private"))
                            module = module.slice(0, -8);
                        includes += ' ' + QtUtils.includesForModule(module, "$$QT_MODULE_INCLUDE_BASE", project.version).join(' ');
                    }

                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine(modulePrefix + "VERSION = " + version);
                    file.writeLine(modulePrefix + "MAJOR_VERSION = " + versionParts[0]);
                    file.writeLine(modulePrefix + "MINOR_VERSION = " + versionParts[1]);
                    file.writeLine(modulePrefix + "PATCH_VERSION = " + versionParts[2]);
                    file.writeLine(modulePrefix + "name = " + product.name);
                    file.writeLine(modulePrefix + "libs = $$QT_MODULE_LIB_BASE");
                    file.writeLine(modulePrefix + "includes = " + includes);
                    file.writeLine(modulePrefix + "DEFINES = " + defines);
                    file.writeLine(modulePrefix + "depends = " + depends);
                    if (isPublic) {
                        file.writeLine(modulePrefix + "bins = $$QT_MODULE_BIN_BASE");
                        file.writeLine(modulePrefix + "libexecs = $$QT_MODULE_LIBEXEC_BASE");
                        file.writeLine(modulePrefix + "plugins = $$QT_MODULE_PLUGIN_BASE");
                        file.writeLine(modulePrefix + "imports = $$QT_MODULE_IMPORT_BASE");
                        file.writeLine(modulePrefix + "qml = $$QT_MODULE_QML_BASE");
                        file.writeLine(modulePrefix + "rpath = " + product.moduleProperty("configure", "prefix") + "/lib");
                        file.writeLine("QT_MODULES += " + module);
                    }

                    file.close();
                }
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
