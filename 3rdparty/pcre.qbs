import qbs

QtProduct {
    targetName: "pcre16"
    type: "staticlibrary"
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    cpp.defines: [
        "HAVE_CONFIG_H",
        "PCRE_STATIC",
    ].concat(base)

    cpp.includePaths: [
        configure.sourcePath + "/qtbase/src/3rdparty/pcre"
    ].concat(base)

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/pcre/"
        files: [
            "*.h",
            "pcre16_*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: configure.sourcePath + "/qtbase/src/3rdparty/pcre"
        cpp.defines: product.cpp.defines
    }
}
