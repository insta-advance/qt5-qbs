import qbs

QtProduct {
    targetName: "pcre16"
    type: "staticlibrary"
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    cpp.defines: {
        var defines = [
            "HAVE_CONFIG_H",
            "PCRE_HAVE_CONFIG_H",
            "PCRE_STATIC",
        ].concat(base);
        if (qbs.targetOS.contains("winrt"))
            defines.push("PCRE_DISABLE_JIT");
        return defines;
    }

    cpp.includePaths: [
        project.sourcePath + "/qtbase/src/3rdparty/pcre"
    ].concat(base)

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
        cpp.defines: product.cpp.defines
    }
}
