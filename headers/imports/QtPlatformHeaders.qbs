import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/platformheaders/"
    files: [
        "eglfsfunctions/*.h",
        "nativecontexts/*.h",
        "windowsfunctions/*.h",
        "xcbfunctions/*.h",
    ]
}
