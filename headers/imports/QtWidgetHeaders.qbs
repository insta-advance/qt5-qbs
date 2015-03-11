import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/widgets/"
    files: [
        "accessible/*.h",
        "dialogs/*.h",
        "effects/*.h",
        "graphicsview/*.h",
        "itemviews/*.h",
        "kernel/*.h",
        "statemachine/*.h",
        "styles/*.h",
        "util/*.h",
        "widgets/*.h",
    ]
}
