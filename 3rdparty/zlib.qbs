import qbs

PkgConfigDependency {
    name: "zlib"
    type: project.system_zlib ? "hpp" : "staticlibrary"
    condition: true
    profiles: project.targetProfiles
    destinationDirectory: project.buildDirectory + "/lib"

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.system_zlib ? includePaths : [
            project.sourceDirectory + "/qtbase/src/3rdparty/zlib",
        ]
    }

    Properties {
        condition: project.system_zlib && !found // e.g. Android
        dynamicLibraries: ["z"]
    }

    Depends { name: "Android.ndk"; condition: qbs.targetOS.contains("android") }
    Depends { name: "cpp" }
    Depends { name: "Qt.core-private"; condition: !project.system_zlib }

    cpp.defines: [
        "QT_BUILD_CONFIGURE",
    ].concat(base)

    Group {
        name: "headers"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/zlib/"
        files: [
            "zutil.h",
            "crc32.h",
            "deflate.h",
            "gzguts.h",
            "inffast.h",
            "inffixed.h",
            "inflate.h",
            "inftrees.h",
            "trees.h",
            "zconf.h",
            "zlib.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/zlib/"
        files: [
            "zutil.c",
            "adler32.c",
            "compress.c",
            "crc32.c",
            "deflate.c",
            "gzclose.c",
            "gzlib.c",
            "gzread.c",
            "gzwrite.c",
            "infback.c",
            "inffast.c",
            "inflate.c",
            "inftrees.c",
            "minigzip.c",
            "trees.c",
            "uncompr.c",
        ]
    }
}
