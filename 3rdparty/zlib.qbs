import qbs

PkgConfigDependency {
    name: "zlib"
    type: project.system_zlib ? "hpp" : "staticlibrary"

    Depends { name: "cpp" }
    Depends { name: "QtCoreHeaders"; condition: !project.system_zlib }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.system_zlib ? base : [
            project.sourceDirectory + "/qtbase/src/3rdparty/zlib",
        ]
    }

    destinationDirectory: project.buildDirectory + "/lib"

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
