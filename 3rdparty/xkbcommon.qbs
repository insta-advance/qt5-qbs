import qbs

QtProduct {
    type: "staticlibrary"
    condition: qbs.targetOS.contains("unix")

    cpp.includePaths: base.concat([
        project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon",
        project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon/src",
    ])

    cpp.cFlags: base.concat(["-std=c99"])

    cpp.defines: base.concat([
        'DFLT_XKB_CONFIG_ROOT="' + qbs.getEnv("CFG_XKB_CONFIG_ROOT") + '"',
        'DEFAULT_XKB_RULES="evdev"',
        'DEFAULT_XKB_MODEL="pc105"',
        'DEFAULT_XKB_LAYOUT="us"',
    ])

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
            "xkbcomp/*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourceDirectory + "/qtbase/src/3rdparty/xkbcommon"
    }
}
