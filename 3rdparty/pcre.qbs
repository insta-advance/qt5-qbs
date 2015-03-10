import qbs

QtProduct {
    targetName: "pcre16"
    type: "staticlibrary"
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    cpp.defines: base.concat([
        "PCRE_HAVE_CONFIG_H",
        "PCRE_STATIC",
    ])

    cpp.includePaths: base.concat([
        project.sourceDirectory + "/qtbase/src/3rdparty/pcre"
    ])

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/pcre/"
        files: [
            "pcre16_*.c",
        ]
        //fileTags: "cpp" // compile C files as CPP
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            project.sourceDirectory + "/qtbase/src/3rdparty/pcre",
        ]
    }
}
