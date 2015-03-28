import qbs

Group {
    name: "headers"
    prefix: configure.sourcePath + "/qtdeclarative/src/quick/"
    files: [
        "*.h",
        "accessible/*.h",
        "designer/*.h",
        "doc/*.h",
        "items/*.h",
        "items/context2d/*.h",
        "scenegraph/*.h",
        "scenegraph/coreapi/*.h",
        "scenegraph/util/*.h",
        "util/*.h",
    ]
}
