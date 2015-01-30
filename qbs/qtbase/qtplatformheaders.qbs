import qbs

QtModule {
    name: "QtPlatformHeaders"

    type: "hpp" // This only generates header sync rules

    Group {
        name: "_headers"
        fileTags: "header_sync"
        prefix: project.sourceDirectory + "/qtbase/src/platformheaders/"
        files: [
            "eglfsfunctions/*.h",
            "nativecontexts/*.h",
            "windowsfunctions/*.h",
            "xcbfunctions/*.h",
        ]
    }
}
