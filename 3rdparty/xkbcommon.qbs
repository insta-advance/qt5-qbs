import qbs

StaticLibrary {
    condition: qbs.targetOS.contains("unix")

    Depends { name: "cpp" }

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon",
        project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon/src",
    ].concat(base)

    cpp.cFlags: [
        "-std=c99",
        "-Wno-conditional-type-mismatch",
        "-Wno-implicit-function-declaration",
        "-Wno-int-conversion",
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
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.h",
            "xkbcomp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.c",
            "x11/*.c",
            "xkbcomp/*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon"
    }
}
