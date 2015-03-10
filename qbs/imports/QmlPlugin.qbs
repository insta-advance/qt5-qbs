import qbs

QtPlugin {
    property path pluginPath

    destinationDirectory: project.buildDirectory + "/qml/" + pluginPath

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary"]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
