import qbs
import qbs.Probes
import qbs.TextFile
import "qbs/utils.js" as Utils

Project {
    name: "QtCore"
    QtModule {
        name: "QtCore"
        property path basePath: configure.sourcePath + "/qtbase/src/corelib"

        includeDependencies: ["QtCore-private"]

        cpp.defines: {
            var defines = [
                "QT_BUILD_CORE_LIB",
            ];

            if (!configure.glib)
                defines.push("QT_NO_GLIB");

            if (!configure.iconv)
                defines.push("QT_NO_ICONV");

            return defines.concat(base);
        }

        cpp.dynamicLibraries: {
            var dynamicLibraries = base;

            if (qbs.targetOS.contains("unix")) {
                dynamicLibraries.push("pthread");
                dynamicLibraries.push("dl");
            }

            return dynamicLibraries;
        }

        cpp.includePaths: [
            configure.sourcePath + "/qtbase/src/3rdparty/forkfd",
        ].concat(base)

        Depends { name: "harfbuzz" }
        Depends { name: "pcre" }
        Depends { name: "QtCoreHeaders" }
        Depends { name: "zlib" }
        Depends { name: "glib"; condition: configure.glib; required: false }

        Properties {
            condition: qbs.targetOS.contains("windows")
            cpp.dynamicLibraries: [
                "shell32",
                "user32",
                "ole32",
                "advapi32",
                "ws2_32",
                "mpr",
                "uuid",
            ].concat(base)
        }

        QtCoreHeaders {
            name: "headers"
            excludeFiles: {
                var files = [];

                if (!qbs.targetOS.contains("blackberry")) {
                    files.push("kernel/qeventdispatcher_blackberry_p.h");
                    files.push("kernel/qppsobject_p.h");
                    files.push("tools/qlocale_blackberry.h");
                }

                if (!qbs.targetOS.contains("osx")) {
                    files.push("io/qfilesystemwatcher_fsevents_p.h");
                }

                if (!qbs.targetOS.contains("unix")) {
                    files.push("io/qfilesystemwatcher_inotify_p.h"),
                            files.push("kernel/qeventdispatcher_unix_p.h");
                }

                if (!qbs.targetOS.contains("windows")) {
                    files.push("io/qwindowspipereader_p.h");
                    files.push("io/qwindowspipewriter_p.h");
                    files.push("io/qfilesystemwatcher_win_p.h");
                    files.push("io/qwinoverlappedionotifier_p.h");
                    files.push("kernel/qeventdispatcher_win_p.h");
                }

                if (!qbs.targetOS.contains("winrt")) {
                    files.push("kernel/qeventdispatcher_winrt_p.h");
                }

                if (!configure.glib) {
                    files.push("kernel/qeventdispatcher_glib_p.h");
                }

                if (!configure.kqueue) {
                    files.push("io/qfilesystemwatcher_kqueue_p.h");
                }

                return files;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: product.basePath + "/"
            files: [
                "animation/*.cpp",
                "codecs/*.cpp",
                "global/*.cpp",
                "io/*.cpp",
                "itemmodels/*.cpp",
                "json/*.cpp",
                "kernel/*.cpp",
                "mimetypes/*.cpp",
                "plugin/*.cpp",
                "statemachine/*.cpp",
                "thread/*.cpp",
                "tools/*.cpp",
                "xml/*.cpp",
            ]
            excludeFiles: {
                var excludeFiles = [
                    "codecs/qiconvcodec.cpp", // ### iconv
                    "codecs/qicucodec.cpp",   // ### icu
                    "io/qfilesystemwatcher_kqueue.cpp",  // ### mac
                    "io/qprocess_wince.cpp",             // ### wince
                    "io/qsettings_mac.cpp",              // ### mac
                    "io/qsettings_winrt.cpp",            // ### winrt
                    "io/qstandardpaths_android.cpp",     // ### android
                    "io/qstandardpaths_blackberry.cpp",  // ### blackberry
                    "io/qstandardpaths_winrt.cpp",       // ### winrt
                    "io/qstorageinfo_mac.cpp",           // ### mac
                    "io/qstorageinfo_stub.cpp",          // ### all-else-fails
                    "kernel/qcoreapplication_mac.cpp",   // ### mac
                    "kernel/qcore_mac.cpp",              // ### mac
                    "kernel/qeventdispatcher_blackberry.cpp", // ### bb
                    "kernel/qeventdispatcher_winrt.cpp", // ### winrt
                    "kernel/qfunctions_nacl.cpp",        // ### nacl
                    "kernel/qfunctions_vxworks.cpp",     // ### vxworks
                    "kernel/qfunctions_wince.cpp",       // ### wince
                    "kernel/qfunctions_winrt.cpp",       // ### winrt
                    "kernel/qjni.cpp",                   // ### jni
                    "kernel/qjnihelpers.cpp",            // ### jni
                    "kernel/qjnionload.cpp",             // ### jni
                    "kernel/qppsattribute.cpp",          // ### bb
                    "kernel/qppsobject.cpp",             // ### bb
                    "kernel/qsharedmemory_android.cpp",  // ### android
                    "kernel/qsystemsemaphore_android.cpp",//### android
                    "kernel/qtcore_eval.cpp",            // ### needs to be handled by config, and use licensing
                    "thread/qthread_winrt.cpp",  // ### winrt
                    "tools/qcollator_icu.cpp",     // ### icu
                    "tools/qcollator_macx.cpp",    // ### macx
                    "tools/qelapsedtimer_generic.cpp", // ### !win32
                    "tools/qelapsedtimer_mac.cpp",  // ### mac
                    "tools/qlocale_blackberry.cpp", // ### bb
                    "tools/qlocale_icu.cpp",        // ### icu
                    "tools/qtimezoneprivate_android.cpp", // ### android
                    "tools/qtimezoneprivate_icu.cpp",     // ### icu
                    // included inline
                    "thread/qmutex_linux.cpp",
                    "thread/qmutex_mac.cpp",
                    "thread/qmutex_unix.cpp",
                    "thread/qmutex_win.cpp",
                    "tools/qchar.cpp",
                    "tools/qunicodetables.cpp",
                    "tools/qstringmatcher.cpp",
                ];

                if (!qbs.targetOS.contains("unix")) {
                    Array.prototype.push.apply(excludeFiles, [
                        "io/forkfd_qt.cpp",
                        "io/qfilesystemengine_unix.cpp",
                        "io/qfilesystemiterator_unix.cpp",
                        "io/qfilesystemwatcher_inotify.cpp",
                        "io/qfsfileengine_unix.cpp",
                        "io/qlockfile_unix.cpp",
                        "io/qprocess_unix.cpp",
                        "io/qstandardpaths_unix.cpp",
                        "io/qstorageinfo_unix.cpp",
                        "kernel/qcore_unix.cpp",
                        "kernel/qcrashhandler.cpp",
                        "kernel/qeventdispatcher_unix.cpp",
                        "kernel/qsharedmemory_posix.cpp",
                        "kernel/qsharedmemory_systemv.cpp",
                        "kernel/qsharedmemory_unix.cpp",
                        "kernel/qsystemsemaphore_posix.cpp",
                        "kernel/qsystemsemaphore_systemv.cpp",
                        "kernel/qsystemsemaphore_unix.cpp",
                        "kernel/qtimerinfo_unix.cpp",
                        "plugin/qlibrary_unix.cpp",
                        "thread/qthread_unix.cpp",
                        "thread/qwaitcondition_unix.cpp",
                        "tools/qelapsedtimer_unix.cpp",
                        "tools/qcollator_posix.cpp",
                        "tools/qlocale_unix.cpp",
                        "tools/qtimezoneprivate_tz.cpp",
                    ]);
                }

                if (!qbs.targetOS.contains("windows")) {
                    Array.prototype.push.apply(excludeFiles, [
                        "codecs/qwindowscodec.cpp",
                        "io/qfilesystemengine_win.cpp",
                        "io/qfilesystemiterator_win.cpp",
                        "io/qfilesystemwatcher_win.cpp",
                        "io/qfsfileengine_win.cpp",
                        "io/qlockfile_win.cpp",
                        "io/qprocess_win.cpp",
                        "io/qsettings_win.cpp",
                        "io/qstandardpaths_win.cpp",
                        "io/qstorageinfo_win.cpp",
                        "io/qwindowspipereader.cpp",
                        "io/qwindowspipewriter.cpp",
                        "io/qwinoverlappedionotifier.cpp",
                        "kernel/qcoreapplication_win.cpp",
                        "kernel/qeventdispatcher_win.cpp",
                        "kernel/qsharedmemory_win.cpp",
                        "kernel/qsystemsemaphore_win.cpp",
                        "kernel/qwineventnotifier.cpp",
                        "plugin/qlibrary_win.cpp",
                        "plugin/qsystemlibrary.cpp",
                        "thread/qwaitcondition_win.cpp",
                        "thread/qmutex_win.cpp",
                        "thread/qthread_win.cpp",
                        "tools/qlocale_win.cpp",
                        "tools/qcollator_win.cpp",
                        "tools/qelapsedtimer_win.cpp",
                        "tools/qtimezoneprivate_win.cpp",
                        "tools/qvector_msvc.cpp",
                    ]);
                }

                if (!qbs.targetOS.contains("haiku")) {
                    Array.prototype.push.apply(excludeFiles, [
                        "io/qstandardpaths_haiku.cpp",
                    ]);
                }

                if (!configure.glib) {
                    Array.prototype.push.apply(excludeFiles, [
                        "kernel/qeventdispatcher_glib.cpp",
                    ]);
                }

                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "mimetypes.qrc"
            files: basePath + "/mimetypes/mimetypes.qrc"
            fileTags: "qrc"
        }

        // ### make these paths configurable
        Transformer {
            Artifact {
                filePath: project.buildDirectory + "/include/QtCore/qconfig.cpp"
                fileTags: "hpp" // included by qlibraryinfo.cpp
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "Preparing qconfig.cpp";
                cmd.sourceCode = function() {
                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    // ### todo: support enterprise licensing
                    outputFile.writeLine('/* License Info */');
                    outputFile.writeLine('static const char qt_configure_licensee_str          [256 + 12] = "qt_lcnsuser=Open Source";'); //### qhost could even patch these
                    outputFile.writeLine('static const char qt_configure_licensed_products_str [256 + 12] = "qt_lcnsprod=OpenSource";');
                    outputFile.writeLine('');
                    outputFile.writeLine('/* Installation date */');
                    outputFile.writeLine('static const char qt_configure_installation          [11 + 12]    = "qt_instdate=2012-12-20";'); //### qhost could patch this, too
                    outputFile.writeLine('');
                    outputFile.writeLine('/* Installation Info */');
                    outputFile.writeLine('static const char qt_configure_prefix_path_str       [256 + 12] = "qt_prfxpath=' + product.moduleProperty("configure", "prefix") + '";'); // ###FIXME: qhost must be able to patch this; like an -install option.
                    outputFile.writeLine('');
                    outputFile.writeLine("static const short qt_configure_str_offsets[] = { 0, 4, 12, 16, 24, 28, 36, 44, 48, 50, 52, 65, 74 };");
                    outputFile.writeLine('static const char  qt_configure_strs[] =');
                    outputFile.writeLine('    "doc\\0"');
                    outputFile.writeLine('    "include\\0"');
                    outputFile.writeLine('    "lib\\0"');
                    outputFile.writeLine('    "libexec\\0"');
                    outputFile.writeLine('    "bin\\0"');
                    outputFile.writeLine('    "plugins\\0"');
                    outputFile.writeLine('    "imports\\0"');
                    outputFile.writeLine('    "qml\\0"');
                    outputFile.writeLine('    ".\\0"');
                    outputFile.writeLine('    ".\\0"');
                    outputFile.writeLine('    "translations\\0"');
                    outputFile.writeLine('    "examples\\0"');
                    outputFile.writeLine('    "tests\\0"');
                    outputFile.writeLine(';');
                    outputFile.writeLine('');
                    if (!product.moduleProperty("qbs", "targetOS").contains("windows"))
                        outputFile.writeLine('#define QT_CONFIGURE_SETTINGS_PATH "/etc/xdg";');
                    outputFile.writeLine('');
                    outputFile.writeLine('/* strlen( "qt_lcnsxxxx" ) == 12 */');
                    outputFile.writeLine('#define QT_CONFIGURE_LICENSEE qt_configure_licensee_str + 12');
                    outputFile.writeLine('#define QT_CONFIGURE_LICENSED_PRODUCTS qt_configure_licensed_products_str + 12');
                    outputFile.writeLine('#define QT_CONFIGURE_PREFIX_PATH qt_configure_prefix_path_str + 12');
                    outputFile.close();
                };
                return cmd;
            }
        }
    }

    Product {
        name: "install"
        type: "install"

        Depends { name: "configure" }

        Transformer {
            Artifact {
                filePath: "qfeatures.h"
                fileTags: "install"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "preparing qfeatures.h";
                cmd.sourceCode = function() {
                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    outputFile.writeLine("#ifndef QFEATURES_H");
                    outputFile.writeLine("#define QFEATURES_H");
                    outputFile.writeLine('');

                    // ### TODO: generate this properly using features.txt

                    var properties = product.moduleProperty("configure", "properties");
                    if (!properties.dbus) {
                        outputFile.writeLine("#define QT_NO_DBUS");
                        outputFile.writeLine("#define QT_NO_ACCESSIBILITY_ATSPI_BRIDGE");
                    }
                    if (!properties.glib)
                        outputFile.writeLine("#define QT_NO_GLIB");
                    if (!properties.iconv)
                        outputFile.writeLine("#define QT_NO_ICONV");
                    if (!properties.widgets)
                        outputFile.writeLine("#define QT_NO_WIDGETS");
                    if (!properties.gtkstyle)
                        outputFile.writeLine("#define QT_NO_STYLE_GTK");
                    if (!properties.androidstyle)
                        outputFile.writeLine("#define QT_NO_STYLE_ANDROID");
                    if (!properties.gtkstyle)
                        outputFile.writeLine("#define QT_NO_STYLE_GTK");
                    if (!properties.macstyle)
                        outputFile.writeLine("#define QT_NO_STYLE_MAC");
                    if (!properties.windowscestyle)
                        outputFile.writeLine("#define QT_NO_STYLE_WINDOWSCE");
                    if (!properties.windowsmobilestyle)
                        outputFile.writeLine("#define QT_NO_STYLE_WINDOWSMOBILE");
                    if (!properties.windowsvistastyle)
                        outputFile.writeLine("#define QT_NO_STYLE_WINDOWSVISTA");
                    if (!properties.windowsxpstyle)
                        outputFile.writeLine("#define QT_NO_STYLE_WINDOWSXP");
                    if (!properties.xkb)
                        outputFile.writeLine("#define QT_NO_XKB");

                    outputFile.writeLine('');
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
                cmd.description = "preparing qconfig.h";
                cmd.defines = product.moduleProperty("configure", "baseDefines").concat(
                              product.moduleProperty("configure", "openglDefines")).concat(
                              product.moduleProperty("configure", "simdDefines"));
                cmd.sourceCode = function() {
                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    outputFile.writeLine("#ifndef QCONFIG_H");
                    outputFile.writeLine("#define QCONFIG_H");
                    outputFile.writeLine('');
                    for (var i in defines) {
                        var define = defines[i].replace(/^(\w+)=/, "$1 ");
                        outputFile.writeLine("#define " + define);
                    }
                    outputFile.writeLine('');
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
                    file.writeLine('    "QMAKE_XSPEC": "' + product.moduleProperty("configure", "mkspec") + '",');
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
                cmd.config = ["shared", product.moduleProperty("qbs", "buildVariant")];
                var properties = product.moduleProperty("configure", "properties");
                cmd.qtconfig = [];
                for (var i in properties) {
                    if (properties[i])
                        cmd.qtconfig.push(i);
                }
                if (properties.opengl == "es2")
                    cmd.qtconfig.push("opengles2");
                cmd.qtVersionParts = product.moduleProperty("configure", "versionParts");
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine("QT_MAJOR_VERSION = " + qtVersionParts[0]);
                    file.writeLine("QT_MINOR_VERSION = " + qtVersionParts[1]);
                    file.writeLine("QT_PATCH_VERSION = " + qtVersionParts[2]);
                    file.writeLine("QT_NAMESPACE = "); // ### namespace
                    file.writeLine("QT_LIBINFIX = "); // ### libinfix
                    file.writeLine("QT_TARGET_ARCH = " + product.moduleProperty("qbs", "architecture"));
                    file.writeLine("CONFIG = " + config.join(' '));
                    file.writeLine("QT_CONFIG = " + qtconfig.join(' '));
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
            files: configure.sourcePath + "/qtbase/mkspecs"
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
