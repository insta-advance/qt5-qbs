import qbs
import qbs.File
import qbs.Probes

QtModule {
    name: "QtGui"
    readonly property path basePath: project.sourceDirectory + "/qtbase/src/gui"

    includeDependencies: ["QtCore-private", "QtGui", "QtGui-private"]

    cpp.defines: base.concat([
        "QT_BUILD_GUI_LIB",
    ])

    Depends { name: "freetype" }
    Depends { name: "jpeg" }
    Depends { name: "png" }
    Depends { name: "QtCore" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "zlib" }

    Properties {
        condition: configure.properties.opengl === undefined
        configure.opengl: "es2" // ### perform detection
    }

    Properties {
        condition: configure.properties.qpa === undefined
        configure.qpa: "xcb" // ### make this smarter
    }

    Properties {
        condition: configure.opengl == "desktop" && qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: base.concat([
            "GL",
        ])
    }

    Properties {
        condition: configure.opengl == "es2"
        cpp.dynamicLibraries: base.concat([
            "GLESv2",
        ])
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: base.concat([
            "opengl32",
            "user32",
            "gdi32",
        ])
    }

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cxxFlags: {
            var cxxFlags = base;
            // ### move these lower, like QtProduct
            if (configure.sse2)
                cxxFlags.push("-msse2");
            if (configure.sse3)
                cxxFlags.push("-msse3");
            if (configure.ssse3)
                cxxFlags.push("-mssse3");
            if (configure.sse4_1)
                cxxFlags.push("-msse4.1");
            if (configure.sse4_2);
                cxxFlags.push("-msse4.2");
            if (configure.avx)
                cxxFlags.push("-mavx");
            if (configure.avx2)
                cxxFlags.push("-mavx2");
            if (configure.neon)
                cxxFlags.push("-mfpu=neon");
            return cxxFlags;
        }
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
        condition: qbs.architecture == "arm"
        prefix: project.sourceDirectory + "/qtbase/src/"
        files: [
            "3rdparty/pixman/pixman-arm-neon-asm.S",
            "gui/painting/qdrawhelper_neon_asm.S",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.dynamicLibraries: product.cpp.dynamicLibraries

        Depends { name: "configure" }
        configure.qpa: product.configure.qpa
        configure.png: product.configure.png
        configure.opengl: product.configure.opengl
    }
}
