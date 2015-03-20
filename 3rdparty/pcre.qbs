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
        project.sourcePath + "/qtbase/src/3rdparty/pcre"
    ])

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/3rdparty/pcre/"
        files: [
            "*.h",
            "pcre16_*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourcePath + "/qtbase/src/3rdparty/pcre"
        cpp.defines: ["PCRE_HAVE_CONFIG_H", "PCRE_STATIC"]
    }
}
