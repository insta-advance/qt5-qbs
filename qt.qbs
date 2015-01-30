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
    property int pointerSize: qbs.architecture == "x86_64" ? 8 : 4

    qbsSearchPaths: "qbs"

    Project {
        name: "qtbase"
        references: [
            //"sync_testbed.qbs",
            "qbs/qtbase/3rdparty/3rdparty.qbs",
            "qbs/qtbase/qtplatformheaders.qbs",
            "qbs/qtbase/qtplatformsupport.qbs",
            "qbs/qtbase/qtcore.qbs",
            "qbs/qtbase/qtgui.qbs",
            "qbs/qtbase/qtnetwork.qbs",
            "qbs/qtbase/plugins/platforms/platforms.qbs",
        ]
    }

    Project {
        name: "qtdeclarative"
        references: [
            "qbs/qtdeclarative/qtqml.qbs",
        ]
    }

    /*Project {
        name: "qtwayland"
        references: [
            "qbs/qtwayland/"
        ]
    }*/

    Product {
        name: "configure"

        Depends { name: "cpp" }
        Depends { name: "QtHost.config" }

        /*Probe {
            property stringList repos: [ "qtbase", "qtdeclarative" ]
            condition: true // Note: set to false during development to avoid slowness
            configure: {
                var cmd = new Process();
                for (var i in repos) {
                    cmd.exec("perl", [
                        sourceDirectory + "/qtbase/bin/syncqt.pl",
                        "-outdir", root.buildDirectory,
                        "-quiet",
                        sourceDirectory + "/" + repos[i]
                    ]);
                }
                cmd.close();
            }
        }*/

        Transformer {
            Artifact {
                fileTags: [ "hpp" ]
                filePath: project.buildDirectory + "/include/QtCore/qfeatures.h"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "Preparing qfeatures.h";
                cmd.sourceCode = function() {
                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    outputFile.writeLine("#ifndef QFEATURES_H");
                    outputFile.writeLine("#define QFEATURES_H");

                    // Untested macros
                    //outputFile.writeLine("#define QT_NO_COMPRESS");

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

                    //if (!product.moduleProperty("QtHost.config", "ssl"))
                    //    outputFile.writeLine("#define QT_NO_SSL");

                    if (!product.moduleProperty("QtHost.config", "glib"))
                        outputFile.writeLine("#define QT_NO_GLIB");

                    if (!product.moduleProperty("QtHost.config", "opengl"))
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
                fileTags: "hpp"
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
                        outputFile.writeLIne("#define QT_OPENGL_DYNAMIC");
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

        Transformer {
            Artifact {
                filePath: project.buildDirectory + "/include/QtCore/qconfig.cpp"
                fileTags: "hpp" // included by qlibraryinfo.cpp
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "Preparing qconfig.cpp";
                cmd.sourceCode = function() {
                    var prefix = project.buildDirectory; // This should be patched at install time
                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    // ### todo: support enterprise licensing
                    outputFile.writeLine("/* Licensed */");
                    outputFile.writeLine("static const char qt_configure_licensee_str          [512 + 12] = \"qt_lcnsuser=Open Source\";");
                    outputFile.writeLine("static const char qt_configure_licensed_products_str [512 + 12] = \"qt_lcnsprod=OpenSource\";");
                    outputFile.writeLine("static const char qt_configure_installation          [11  + 12] = \"qt_instdate=0123456789\";"); // ### (new Date()).toISOString().slice(10) if this is needed
                    outputFile.writeLine("/* Installation Info */");
                    outputFile.writeLine("static const char qt_configure_prefix_path_str       [512 + 12] = \"qt_prfxpath=" + prefix + "\";");
                    outputFile.writeLine("");
                    outputFile.writeLine("static const short qt_configure_str_offsets[] = { };");
                    outputFile.writeLine("static const char  qt_configure_strs[] = { };");
                    outputFile.writeLine("static const char qt_configure_prefix_path_strs[][12 + 512] = {");
                    outputFile.writeLine("    \"qt_prfxpath=" + prefix + "\",");
                    outputFile.writeLine("    \"qt_docspath=" + prefix + "/doc\",");
                    outputFile.writeLine("    \"qt_hdrspath=" + prefix + "/include\",");
                    outputFile.writeLine("    \"qt_libspath=" + prefix + "/lib\",");
                    outputFile.writeLine("    \"qt_lbexpath=" + prefix + "/bin\",");
                    outputFile.writeLine("    \"qt_binspath=" + prefix + "/bin\",");
                    outputFile.writeLine("    \"qt_plugpath=" + prefix + "/plugins\",");
                    outputFile.writeLine("    \"qt_impspath=" + prefix + "/imports\",");
                    outputFile.writeLine("    \"qt_qml2path=" + prefix + "/qml\",");
                    outputFile.writeLine("    \"qt_adatpath=" + prefix + "\",");
                    outputFile.writeLine("    \"qt_datapath=" + prefix + "\",");
                    outputFile.writeLine("    \"qt_trnspath=" + prefix + "/translations\",");
                    outputFile.writeLine("    \"qt_xmplpath=" + prefix + "/examples\",");
                    outputFile.writeLine("    \"qt_tstspath=" + prefix + "/tests\",");
                    outputFile.writeLine("};");
                    outputFile.writeLine("");
                    outputFile.writeLine("/* strlen( \"qt_lcnsxxxx\") == 12 */");
                    outputFile.writeLine("#define QT_CONFIGURE_LICENSEE qt_configure_licensee_str + 12;");
                    outputFile.writeLine("#define QT_CONFIGURE_LICENSED_PRODUCTS qt_configure_licensed_products_str + 12;");
                    if (!project.target.contains("win")) {
                        var configureSettingsPath = "/etc/xdg"; // ### make accessible from configure
                        outputFile.writeLine("static const char qt_configure_settings_path_str [256 + 12] = \"qt_stngpath="
                                              + configureSettingsPath + "\";");
                        outputFile.writeLine("#define QT_CONFIGURE_SETTINGS_PATH qt_configure_settings_path_str + 12;");
                    }
                    outputFile.writeLine("#define QT_CONFIGURE_PREFIX_PATH qt_configure_prefix_path_str + 12\n");
                    outputFile.close();
                };
                return cmd;
            }
        }
    }
}
