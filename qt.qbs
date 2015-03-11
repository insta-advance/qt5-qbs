import qbs 1.0
import qbs.TextFile
import qbs.Process

Project {
    id: root

    property string target: {
        var host;
        if (qbs.targetOS.contains("linux")) {
            if (qbs.toolchain.contains("clang"))
                host = "linux-clang";
            else if (qbs.toolchain.contains("gcc"))
                host = "linux-g++";
        } else if (qbs.targetOS.contains("winphone")) {
            switch (qbs.architecture) {
            case "x86":
                host = "winphone-x86-msvc2013";
                break;
            case "x86_64":
                host = "winphone-x64-msvc2013";
                break;
            case "arm":
                host = "winphone-arm-msvc2013";
                break;
            }
        } else if (qbs.targetOS.contains("winrt")) {
            switch (qbs.architecture) {
            case "x86":
                host = "winrt-x86-msvc2013";
                break;
            case "x86_64":
                host = "winrt-x64-msvc2013";
                break;
            case "arm":
                host = "winrt-arm-msvc2013";
                break;
            }
        } else if (qbs.targetOS.contains("windows")) {
            if (qbs.toolchain.contains("mingw"))
                host = "win32-g++";
            else if (qbs.toolchain.contains("msvc"))
                host = "win32-msvc2013";
        }
        return host;
    }

    property string qtVersion: "5.5.0"

    qbsSearchPaths: ["qbs", "headers"]

    references: [
        "3rdparty/3rdparty.qbs",

        "headers/headers.qbs",
        "qtcore.qbs",
        "qtgui.qbs",
        "qtnetwork.qbs",

        "qtqml.qbs",
        "qtquick.qbs",

        "qtmultimedia.qbs",
        "multimedia-support.qbs",

        "imports/imports.qbs",
    ]

    Project {
        name: "plugins"

        Project {
            name: "platforms"
            references: [
                "plugins/platforms/eglfs.qbs",
                "plugins/platforms/xcb.qbs",
            ]
        }

        Project {
            name: "mediaservice"
            references: [
                "plugins/mediaservice/gstreamer-camerabin.qbs",
            ]
        }

        Project {
            name: "video"
            references: [
                "plugins/video/videonode-egl.qbs",
                "plugins/video/videonode-imx6.qbs",
            ]
        }
    }

    // Rules for installation only
    Product {
        type: "install"

        Transformer {
            Artifact {
                filePath: "qfeatures.h"
                fileTags: "install"
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

        Transformer {
            Artifact {
                filePath: "qconfig.h"
                fileTags: "install"
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
            fileTagsFilter: "qhost.json"
            qbs.install: true
            qbs.installDir: "bin"
        }

        Group {
            name: "mkspecs"
            files: "qtbase/mkspecs"
            fileTags: []
            qbs.install: true
        }

        Group {
            fileTagsFilter: "qconfig.pri"
            qbs.install: true
            qbs.installDir: "mkspecs"
        }

        Group {
            name: "configuration headers"
            fileTagsFilter: "install"
            qbs.install: true
            qbs.installDir: "include/QtCore"
        }
    }
}
