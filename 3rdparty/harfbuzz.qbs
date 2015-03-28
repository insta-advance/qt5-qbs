import qbs

QtProduct {
    type: "staticlibrary"

    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/harfbuzz/src/"
        files: [
            "harfbuzz-buffer.c",
            "harfbuzz-gdef.c",
            "harfbuzz-gpos.c",
            "harfbuzz-gsub.c",
            "harfbuzz-impl.c",
            "harfbuzz-open.c",
            "harfbuzz-shaper-all.cpp",
            "harfbuzz-stream.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            configure.sourcePath + "/qtbase/src/3rdparty/harfbuzz/src",
        ]
    }
}
