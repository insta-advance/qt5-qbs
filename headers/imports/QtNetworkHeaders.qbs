import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/network/"
    files: [
        "access/*.h",
        "bearer/*.h",
        "kernel/*.h",
        "socket/*.h",
        "ssl/*.h",
    ]
}
