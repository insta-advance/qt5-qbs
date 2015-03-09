import qbs
import qbs.File
import qbs.FileInfo
import qbs.Probes
import qbs.TextFile

// This Product attempts to handle only installation-time files.
// ### TODO: replace all build-time artifacts (qfeatures, qconfig, etc.) with static files and rename this product to install
// ### TODO: configuration should be done as follows:
// - a base configuration file is checked. this file is gitignored and included and user customizable.
// - for anything not found, a probe is run
// - an output is created which is read here.

// the configuration type stuff should be moved to the configuration module, and this project
// only creates the installation files. the module itself is responsible for choosing the configuration.
// that would imply that this product has an optional dependency on every module that contributes to the global configuration.

Product {
    Depends { name: "cpp" }
    Depends { name: "configure" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }

    // ### each module exports defines instead, or maybe QtCore just installs this.
    Transformer {
        Artifact {
            filePath: "qfeatures.h"
            fileTags: ["hpp", "qconfig"]
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "Preparing qfeatures.h";
            cmd.sourceCode = function() {
                var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                outputFile.writeLine("#ifndef QFEATURES_H");
                outputFile.writeLine("#define QFEATURES_H");

                var defines = product.moduleProperty("configure", "defines");
                for (var i in defines) {
                    var define = defines[i];
                    if (define.startsWith("QT_NO_"))
                        outputFile.writeLine("#define " + define);
                }

                outputFile.writeLine("#endif // QFEATURES_H");
                outputFile.close();
            };
            return cmd;
        }
    }

    // This definitely feels like something which should be combined + installed, not used at build time
    Transformer {
        Artifact {
            filePath: "qconfig.h"
            fileTags: ["hpp", "qconfig"]
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "Preparing qconfig.h";
            cmd.sourceCode = function() {
                var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                outputFile.writeLine("#ifndef QCONFIG_H");
                outputFile.writeLine("#define QCONFIG_H");

                var defines = product.moduleProperty("configure", "defines");
                for (var i in defines) {
                    var define = defines[i];
                    if (!define.startsWith("QT_NO_"))
                        outputFile.writeLine("#define " + define);
                }

                outputFile.writeLine("#endif // QCONFIG_H");
                outputFile.close();
            };
            return cmd;
        }
    }

    Group {
        name: "bin"
        files: [ // Scripts to forward host tools commands
            "bin/moc",
            "bin/qmake",
            "bin/rcc",
        ]
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "mkspecs"
        files: "qtbase/mkspecs/"
        fileTags: []
        qbs.install: true
    }

    // While these are part of QtCore, they are part of the install more than the build
    Group {
        name: "configuration headers"
        fileTagsFilter: "qconfig"
        qbs.install: true
        qbs.installDir: "include/QtCore"
    }

    // ### make all this configurable
    Transformer {
        Artifact {
            filePath: "qhost.json"
            fileTags: "qhost.json"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "creating qhost JSON configuration file"
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine('{');
                file.writeLine('    "QMAKE_XSPEC": "' + project.target + '",');
                file.writeLine('    "QT_HOST_BINS": "../bin",');
                file.writeLine('    "QT_HOST_DATA": "..",');
                file.writeLine('    "QT_HOST_LIBS": "../lib",');
                file.writeLine('    "QT_HOST_PREFIX": "..",');
                file.writeLine('    "QT_INSTALL_BINS": "../bin",');
                file.writeLine('    "QT_INSTALL_HEADERS": "../include",');
                file.writeLine('    "QT_INSTALL_LIBS": "../lib",');
                file.writeLine('    "QT_INSTALL_PLUGINS": "../plugins",');
                file.writeLine('    "QT_VERSION": "' + project.qtVersion + '"');
                file.writeLine('}');
            };
            return cmd;
        }
    }

    Group {
        fileTagsFilter: "qhost.json"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Transformer {
        Artifact {
            filePath: "qconfig.pri"
            fileTags: "qconfig.pri"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating qconfig.pri";
            cmd.sourceCode = function() {
                var config = product.moduleProperty("configure", "config");
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("QT_MAJOR_VERSION = 5"); // ### get from project.version
                file.writeLine("QT_MINOR_VERSION = 5");
                file.writeLine("QT_PATCH_VERSION = 0");
                file.writeLine("QT_NAMESPACE = "); // ### namespace
                file.writeLine("QT_LIBINFIX = "); // ### libinfix
                file.writeLine("QT_TARGET_ARCH = " + product.moduleProperty("qbs", "architecture"));
                // ### fixme: separate CONFIG and QT_CONFIG
                file.writeLine("CONFIG = " + config.join(' '));
                file.writeLine("QT_CONFIG = " + config.join(' '));
                file.close();
            }
            return cmd;
        }
    }

    Group {
        fileTagsFilter: "qconfig.pri"
        qbs.install: true
        qbs.installDir: "mkspecs"
    }
}
