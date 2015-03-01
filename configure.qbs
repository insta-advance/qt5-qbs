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
                // ### todo: create date from the last commit; (new Date()).toISOString().slice(10)
                outputFile.writeLine("static const char qt_configure_installation          [11  + 12] = \"qt_instdate=0123456789\";");
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

    // Script to pass qmake commands to qhost (###todo: add .bat version)
    Group {
        name: "bin"
        files: "bin/qmake"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "mkspecs"
        files: "qtbase/mkspecs/"
        fileTags: []
        qbs.install: true
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
}
