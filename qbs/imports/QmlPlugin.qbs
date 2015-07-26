import qbs

QtProduct {
    property path pluginPath

    type: "dynamiclibrary"
    destinationDirectory: project.buildDirectory + "/qml/" + pluginPath

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary", "qml"]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
