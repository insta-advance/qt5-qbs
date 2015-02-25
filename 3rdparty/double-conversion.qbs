import qbs

StaticLibrary {
    readonly property string basePath: project.sourceDirectory
                                       + "/qtdeclarative/src/3rdparty/double-conversion"

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
