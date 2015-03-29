import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/corelib/"
    files: [
        "mimetypes/*.h",
        "statemachine/*.h",
        "global/*.h",
        "kernel/*.h",
        "arch/*.h",
        "json/*.h",
        "io/*.h",
        "tools/*.h",
        "itemmodels/*.h",
        "thread/*.h",
        "animation/*.h",
        "codecs/*.h",
        "plugin/*.h",
        "xml/*.h",
    ]
}
