import qbs

Group {
    name: "headers"
    prefix: configure.sourcePath + "/qtbase/src/gui/"
    files: [
        "accessible/*.h",
        "animation/*.h",
        "image/*.h",
        "itemmodels/*.h",
        "kernel/*.h",
        "math3d/*.h",
        "opengl/*.h",
        "painting/*.h",
        "text/*.h",
        "util/*.h",
    ]
}
