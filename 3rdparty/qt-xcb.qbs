import qbs

QtProduct {
    type: "staticlibrary"
    condition: qbs.targetOS.contains("linux") && !qbs.targetOS.contains("android")

    readonly property path basePath: project.sourcePath + "/qtbase/src/3rdparty/xcb"

    cpp.cFlags: [
        "-Wno-implicit-function-declaration",
        "-Wno-sign-compare",
        "-Wno-tautological-compare",
        "-Wno-unused-parameter",
    ].concat(base)

    cpp.includePaths: [
        basePath + "/include",
        basePath + "/include/xcb",
        basePath + "/sysinclude",
    ].concat(base)

    Group {
        name: "headers"
        files: basePath + "/include/xcb/*.h"
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "libxcb/*.c",
            "xcb-util/*.c",
            "xcb-util-image/*.c",
            "xcb-util-keysyms/*.c",
            "xcb-util-renderutil/*.c",
            "xcb-util-wm/*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            project.sourcePath + "/qtbase/src/3rdparty/xcb/include",
            project.sourcePath + "/qtbase/src/3rdparty/xcb/sysinclude",
        ]
    }
}
