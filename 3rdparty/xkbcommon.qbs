import qbs

QtProduct {
    type: "staticlibrary"
    condition: qbs.targetOS.contains("unix")

    cpp.includePaths: [
        configure.sourcePath + "/qtbase/src/3rdparty/xkbcommon",
        configure.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src",
    ].concat(base)

    cpp.cFlags: [
        "-Wno-implicit-function-declaration",
        "-Wno-missing-field-initializers",
        "-Wno-unused-parameter",
    ].concat(base)

    readonly property string xkbConfigRoot: qbs.getEnv("CFG_XKB_CONFIG_ROOT")

    cpp.defines: [
        'DFLT_XKB_CONFIG_ROOT="' + (xkbConfigRoot || "not found") + '"',
        'DEFAULT_XKB_RULES="evdev"',
        'DEFAULT_XKB_MODEL="pc105"',
        'DEFAULT_XKB_LAYOUT="us"',
    ].concat(base)

    Group {
        name: "headers"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.h",
            "xkbcomp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.c",
            "xkbcomp/*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: configure.sourcePath + "/qtbase/src/3rdparty/xkbcommon"
    }
}
