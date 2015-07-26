import qbs

StaticLibrary {
    condition: project.xcb
    destinationDirectory: project.buildDirectory + "/lib"
    profiles: project.targetProfiles

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/3rdparty/xcb"

    Depends { name: "cpp" }

    cpp.cFlags: [
        "-Wno-implicit-function-declaration",
        "-Wno-return-type",
        "-Wno-sign-compare",
        "-Wno-tautological-compare",
        "-Wno-unused-function",
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
            project.sourceDirectory + "/qtbase/src/3rdparty/xcb/include",
            project.sourceDirectory + "/qtbase/src/3rdparty/xcb/sysinclude",
        ]
    }
}
