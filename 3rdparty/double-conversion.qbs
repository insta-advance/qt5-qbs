import qbs

QtProduct {
    readonly property string basePath: project.sourceDirectory
                                       + "/qtdeclarative/src/3rdparty/double-conversion"

    type: "staticlibrary"
    profiles: project.targetProfiles
    builtByDefault: false

    Depends { name: "cpp" }

    files: [
        basePath + "/*.h",
        basePath + "/*.cc",
    ]

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: product.basePath
    }
}
