import qbs

StaticLibrary {
    targetName: "pcre16"
    destinationDirectory: project.buildDirectory + "/lib"
    profiles: project.targetProfiles

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
        project.sourceDirectory + "/qtbase/src/3rdparty/pcre"
    ].concat(base)

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/pcre/"
        files: [
            "*.h",
            "pcre16_*.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourceDirectory + "/qtbase/src/3rdparty/pcre"
        cpp.defines: product.cpp.defines
    }
}
