import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/platformheaders/"
    files: [
        "eglfsfunctions/*.h",
        "nativecontexts/*.h",
        "windowsfunctions/*.h",
        "xcbfunctions/*.h",
    ]
}
