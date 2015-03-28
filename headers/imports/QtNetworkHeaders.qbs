import qbs

Group {
    name: "headers"
    prefix: configure.sourcePath + "/qtbase/src/network/"
    files: [
        "access/*.h",
        "bearer/*.h",
        "kernel/*.h",
        "socket/*.h",
        "ssl/*.h",
    ]
}
