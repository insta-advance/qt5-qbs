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

                //###todo: for each define in configure.defines, only QT_NO_XXX

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

                //###todo: for each define in configure.defines, only non-QT_NO_XXX

                //###move to configure
                /*if (configure.qreal !== undefined) {
                    outputFile.writeLine("#define QT_COORD_TYPE " + product.configuration.qreal);
                    outputFile.writeLine("#define QT_COORD_TYPE_STRING " + product.configuration.qreal);
                }*/

                outputFile.writeLine("#endif // QCONFIG_H");
                outputFile.close();
            };
            return cmd;
        }
    }

    Group {
        name: "bin"
        files: [
            "bin/qmake", // Script to pass qmake commands to qhost (###todo: add .bat version)
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
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("QT_MAJOR_VERSION = 5"); // ### get from project.version
                file.writeLine("QT_MINOR_VERSION = 5");
                file.writeLine("QT_PATCH_VERSION = 0");
                file.writeLine("QT_NAMESPACE = "); // ### namespace
                file.writeLine("QT_LIBINFIX = "); // ### libinfix
                file.writeLine("QT_TARGET_ARCH = " + product.moduleProperty("qbs", "architecture"));
                file.writeLine("CONFIG = shared qpa debug"); // ### static, debug, qt_no_framework...
                //file.writeLine("QT_CONFIG = " + configure.properties.join(' ')); // ### get the real combined configure properties
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
