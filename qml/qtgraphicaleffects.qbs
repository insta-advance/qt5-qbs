import qbs
import qbs.File

QmlPlugin {
    name: "QtGraphicalEffects"
    condition: File.exists(project.sourcePath + "/qtgraphicaleffects")
    pluginPath: "QtGraphicalEffects"
    type: "qml"

    Group {
        name: "qml"
        prefix: project.sourcePath + "/qtgraphicaleffects/src/effects/"
        files: [
            "*.qml",
            "private",
            "qmldir",
        ]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
