import qbs
import qbs.TextFile

// This Product attempts to handle only installation-time files.
// ### TODO: replace all build-time artifacts (qfeatures, qconfig, etc.) with static files and rename this product to install
Product {
    type: "hpp"

    Depends { name: "cpp" }
    Depends { name: "QtHost.config" }

    Transformer {
        Artifact {
            filePath: project.buildDirectory + "/include/QtCore/qfeatures.h"
            fileTags: ["hpp", "qconfig"]
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "Preparing qfeatures.h";
            cmd.sourceCode = function() {
                var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                outputFile.writeLine("#ifndef QFEATURES_H");
                outputFile.writeLine("#define QFEATURES_H");

                if (!product.moduleProperty("QtHost.config", "evdev"))
                    outputFile.writeLine("#define QT_NO_EVDEV");

                if (!product.moduleProperty("QtHost.config", "cursor")) {
                    outputFile.writeLine("#define QT_NO_CURSOR");
                    outputFile.writeLine("#define QT_NO_WHEELEVENT");
                    outputFile.writeLine("#define QT_NO_DRAGANDDROP");
                }

                if (!product.moduleProperty("QtHost.config", "pcre"))
                    outputFile.writeLine("#define QT_NO_REGULAREXPRESSION");

                if (!product.moduleProperty("QtHost.config", "iconv"))
                    outputFile.writeLine("#define QT_NO_ICONV");

                if (!product.moduleProperty("QtHost.config", "glib"))
                    outputFile.writeLine("#define QT_NO_GLIB");

                var opengl = product.moduleProperty("QtHost.config", "opengl");
                if (!opengl)
                    outputFile.writeLine("#define QT_NO_OPENGL");

                outputFile.writeLine("#endif // QFEATURES_H");
                outputFile.close();
            };
            return cmd;
        }
    }

    Transformer {
        Artifact {
            filePath: project.buildDirectory + "/include/QtCore/qconfig.h"
            fileTags: ["hpp", "qconfig"]
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "Preparing qconfig.h";
            cmd.sourceCode = function() {
                var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                outputFile.writeLine("#ifndef QCONFIG_H");
                outputFile.writeLine("#define QCONFIG_H");

                outputFile.writeLine("// Compiler sub-arch support");
                if (product.moduleProperty("QtHost.config", "sse2"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_SSE2 1");
                if (product.moduleProperty("QtHost.config", "sse3"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_SSE3 1");
                if (product.moduleProperty("QtHost.config", "ssse3"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_SSSE3 1");
                if (product.moduleProperty("QtHost.config", "sse4_1"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_SSE4_1 1");
                if (product.moduleProperty("QtHost.config", "sse4_2"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_SSE4_2 1");
                if (product.moduleProperty("QtHost.config", "avx"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_AVX 1");
                if (product.moduleProperty("QtHost.config", "avx2"))
                    outputFile.writeLine("#define QT_COMPILER_SUPPORTS_AVX2 1");

                var opengl = product.moduleProperty("QtHost.config", "opengl");
                if (opengl == "es2") {
                    outputFile.writeLine("#define QT_OPENGL_ES");
                    outputFile.writeLine("#define QT_OPENGL_ES_2");
                } else if (opengl == "dynamic") {
                    outputFile.writeLine("#define QT_OPENGL_DYNAMIC");
                }

                // ### handle qreal
                /*if (project.qreal != undefined) {
                    outputFile.writeLine("#define QT_COORD_TYPE " + project.qreal);
                    outputFile.writeLine("#define QT_COORD_TYPE_STRING " + project.qreal);
                }*/
                outputFile.writeLine("#define QT_USE_BUNDLED_LIBPNG");
                outputFile.writeLine("#define QT_POINTER_SIZE " + project.pointerSize);

                // Qt currently doesn't build without this
                outputFile.writeLine("#define QT_USE_QSTRINGBUILDER");

                // ###
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
                var binPath = product.moduleProperty("QtHost.config", "qhostBinPath");
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine('{');
                file.writeLine('    "QMAKE_XSPEC": "' + project.target + '",');
                file.writeLine('    "QT_HOST_BINS": "' + binPath + '",');
                file.writeLine('    "QT_HOST_DATA": "..",');
                file.writeLine('    "QT_HOST_LIBS": "../lib",');
                file.writeLine('    "QT_HOST_PREFIX": "..",');
                file.writeLine('    "QT_INSTALL_BINS": "' + binPath + '",');
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
                file.writeLine("QT_CONFIG = egl opengl opengles2"); // ### QtHost.config
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
