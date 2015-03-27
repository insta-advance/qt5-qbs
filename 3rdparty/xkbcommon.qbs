import qbs

QtProduct {
    type: "staticlibrary"
    condition: qbs.targetOS.contains("unix")

    cpp.includePaths: base.concat([
        project.sourcePath + "/qtbase/src/3rdparty/xkbcommon",
        project.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src",
    ])

    cpp.cFlags: base.concat(["-std=c99"])

    readonly property string xkbConfigRoot: qbs.getEnv("CFG_XKB_CONFIG_ROOT")

    cpp.defines: base.concat([
        'DFLT_XKB_CONFIG_ROOT="' + (xkbConfigRoot || "not found") + '"',
        'DEFAULT_XKB_RULES="evdev"',
        'DEFAULT_XKB_MODEL="pc105"',
        'DEFAULT_XKB_LAYOUT="us"',
    ])

    Group {
        name: "headers"
        prefix: project.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.h",
            "xkbcomp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/3rdparty/xkbcommon/src/"
        files: [
            "*.c",
            "xkbcomp/*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourcePath + "/qtbase/src/3rdparty/xkbcommon"
    }
}
