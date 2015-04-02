import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtdeclarative/src/qmltest/"
    files: [
        "*.h",
        "3rdparty/*.h",
    ]
}
