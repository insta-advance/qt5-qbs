import qbs

Group {
    name: "headers"
    prefix: configure.sourcePath + "/qtsvg/src/svg/"
    files: [
        "*.h",
    ]
}
