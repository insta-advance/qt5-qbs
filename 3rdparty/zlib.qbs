import qbs

// ### add PkgConfig here so the host libs can be used instead
QtProduct {
    type: "staticlibrary"
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    cpp.defines: [
        "QT_BUILD_CONFIGURE",
        "QT_POINTER_SIZE=" + (qbs.architecture == "x86_64" ? "8" : "4"),
    ].concat(base)

    cpp.includePaths: [
        project.sourceDirectory + "/include",
        project.sourceDirectory + "/include/QtCore",
        configure.sourcePath + "/qtbase/src/corelib/global",
    ].concat(base)

    Group {
        name: "headers"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/zlib/"
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
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/zlib/"
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

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: configure.sourcePath + "/qtbase/src/3rdparty/zlib"
    }
}
