import qbs

QtProduct {
    readonly property string basePath: project.sourcePath
                                       + "/qtdeclarative/src/3rdparty/double-conversion"

    type: "staticlibrary"

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
