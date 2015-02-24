import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/network/"
    files: [
        "access/*.h",
        "bearer/*.h",
        "kernel/*.h",
        "socket/*.h",
        "ssl/*.h",
    ]
}
