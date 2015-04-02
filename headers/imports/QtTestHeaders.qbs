import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/testlib/"
    files: [
        "*.h",
        "3rdparty/*.h",
    ]
}
