import qbs

StaticLibrary {
    destinationDirectory: project.buildDirectory + "/lib"
    profiles: project.targetProfiles
    builtByDefault: false

    Depends { name: "Android.ndk"; condition: qbs.targetOS.contains("android") }
    Depends { name: "cpp" }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/harfbuzz/src/"
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
            project.sourceDirectory + "/qtbase/src/3rdparty/harfbuzz/src",
        ]
    }
}
