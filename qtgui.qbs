import qbs
import qbs.File

QtModule {
    name: "QtGui"
    readonly property path basePath: project.sourceDirectory + "/qtbase/src/gui"

    readonly property stringList inheritedDefines: {
        var defines = [];

        if (!QtHost.config.cursor) {
            defines.push("QT_NO_CURSOR");
            defines.push("QT_NO_WHEELEVENT");
            defines.push("QT_NO_DRAGANDDROP");
        }

        return defines;
    }

    includeDependencies: ["QtCore", "QtCore-private", "QtGui", "QtGui-private"]

    cpp.defines: {
        var defines = product.inheritedDefines;
        defines.push("QT_BUILD_GUI_LIB");

        // ### QtHost.config.defaultPlatformName
        if (project.target.startsWith("linux"))
            defines.push('QT_QPA_DEFAULT_PLATFORM_NAME="eglfs"');

        return defines;
    }

    Depends { name: "freetype" }
    Depends { name: "jpeg" }
    Depends { name: "png" }
    Depends { name: "QtCore" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "zlib" }

    Properties {
        condition: QtHost.config.opengl == "desktop" && qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: base.concat([
            "GL",
        ])
    }

    Properties {
        condition: QtHost.config.opengl == "es2"
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

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
        prefix: basePath + "/"
        fileTags: "moc_hpp_p"
        files: [
            "image/qmovie.h",
            "itemmodels/qstandarditemmodel.h",
            "kernel/qguiapplication.h",
            "kernel/qinputmethod.h",
            "kernel/qwindow.h",
            "kernel/qplatformsystemtrayicon.h",
            "opengl/qopengldebug.h",
            "opengl/qopenglvertexarrayobject.h",
            "text/qabstracttextdocumentlayout.h",
            "text/qsyntaxhighlighter.h",
            "text/qtextdocumentlayout_p.h",
        ]
    }

    QtGuiHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: {
            var files = [
                "util/qlayoutpolicy_p.h", // "Class declaration lacks Q_OBJECT macro."
            ].concat(headers_moc_p.files);

            return files;
        }
    }

    Group {
        id: sources_moc
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
            "image/qpixmapcache.cpp",
            "util/qdesktopservices.cpp",
        ]
        fileTags: "moc_cpp"
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
            "painting/*.cpp",
            "painting/*.c",
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
                "painting/qdrawhelper_neon.cpp", // ## neon
                "painting/qdrawhelper_neon_asm.S",

                "text/qharfbuzzng.cpp", // ### hb-ng?

                // included inline
                "text/qcssscanner.cpp",
            ];

            if (!qbs.targetOS.contains("windows")) {
                Array.prototype.push.apply(excludeFiles, [
                    "image/qpixmap_win.cpp",
                ]);
            }

            if (QtHost.config.opengl != "es2") {
                Array.prototype.push.apply(excludeFiles, [
                    "opengl/qopenglfunctions_es2.cpp",
                ]);
            }

            if (QtHost.config.opengl != "desktop") {
                Array.prototype.push.apply(excludeFiles, [
                    "opengl/qopengltimerquery.cpp",
                    "opengl/qopenglfunctions_1*.cpp",
                    "opengl/qopenglfunctions_2*.cpp",
                    "opengl/qopenglfunctions_3*.cpp",
                    "opengl/qopenglfunctions_4*.cpp",
                    "opengl/qopengltimerquery.cpp",
                ]);
            }

            return excludeFiles.concat(sources_moc.files);
        }
    }
}
