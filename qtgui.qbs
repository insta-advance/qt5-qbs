import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtGui"

    Project {
        name: "platforms"
        references: [
            "gui/platforms/eglfs.qbs",
            "gui/platforms/xcb.qbs",
            "gui/platforms/windows.qbs",
        ]
    }

    QtModule {
        name: "QtGui"
        condition: configure.gui

        readonly property path basePath: configure.sourcePath + "/qtbase/src/gui"

        includeDependencies: ["QtCore-private", "QtGui-private"]

        cpp.defines: {
            var defines = [
                "QT_BUILD_GUI_LIB",
                'QT_QPA_DEFAULT_PLATFORM_NAME="' + configure.qpa + '"',
            ];

            if (configure.png == "qt")
                defines.push("QT_USE_BUNDLED_LIBPNG");

            if (!configure.cursor)
                defines.push("QT_NO_CURSOR");

            return defines.concat(base).concat(configure.simdDefines).concat(configure.openglDefines);
        }

        Depends { name: "opengl" }
        Depends { name: "freetype" }
        Depends { name: "jpeg" }
        Depends { name: "png" }
        Depends { name: "QtCore" }
        Depends { name: "QtGuiHeaders" }
        Depends { name: "zlib" }

        Properties {
            condition: qbs.targetOS.contains("windows")
            cpp.dynamicLibraries: [
                "opengl32",
                "user32",
                "gdi32",
            ].concat(outer)
        }

        QtGuiHeaders {
            name: "headers"
            excludeFiles: {
                var excludeFiles = [];
                if (configure.opengl == "es2")
                    excludeFiles.push("opengl/qopengltimerquery.h");
                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: [
                "accessible/*.cpp",
                "animation/*.cpp",
                "image/*.cpp",
                "itemmodels/*.cpp",
                "kernel/*.cpp",
                "math3d/*.cpp",
                "opengl/*.cpp",
                "painting/*.c",
                "painting/*.cpp",
                "text/*.cpp",
                "util/*.cpp",
            ]
            excludeFiles: {
                var excludeFiles = [
                    "image/qimage_mips_dspr2.cpp",      // ### mips
                    //"image/qjpeghandler.cpp",
                    "painting/qdrawhelper_mips_dsp.cpp",       // ## mips
                    "painting/qdrawhelper_mips_dsp_asm.S",
                    "painting/qdrawhelper_mips_dspr2_asm.S",

                    "text/qharfbuzzng.cpp", // ### hb-ng?

                    // included inline
                    "text/qcssscanner.cpp",
                    "text/qfontsubset_agl.cpp",
                ];

                if (!qbs.architecture == "arm") {
                    Array.prototype.push.apply(excludeFiles, [
                       "painting/qdrawhelper_neon.cpp",
                    ]);
                }

                if (!qbs.targetOS.contains("windows")) {
                    Array.prototype.push.apply(excludeFiles, [
                        "image/qpixmap_win.cpp",
                    ]);
                }

                if (configure.opengl != "es2") {
                    Array.prototype.push.apply(excludeFiles, [
                        "opengl/qopenglfunctions_es2.cpp",
                    ]);
                }

                if (configure.opengl != "desktop") {
                    Array.prototype.push.apply(excludeFiles, [
                        "opengl/qopengltimerquery.cpp",
                        "opengl/qopenglfunctions_1*.cpp",
                        "opengl/qopenglfunctions_2*.cpp",
                        "opengl/qopenglfunctions_3*.cpp",
                        "opengl/qopenglfunctions_4*.cpp",
                        "opengl/qopengltimerquery.cpp",
                    ]);
                }

                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources (pixman neon)"
            condition: configure.neon
            prefix: configure.sourcePath + "/qtbase/src/"
            files: [
                "3rdparty/pixman/pixman-arm-neon-asm.S",
                "gui/painting/qdrawhelper_neon_asm.S",
            ]
        }

        Export {
            Depends { name: "cpp" }
            cpp.defines: configure.openglDefines
        }
    }
}
