import qbs
import qbs.File

Project {
    name: "QtGraphicalEffects"
    condition: File.exists(project.sourcePath + "/qtgraphicaleffects")
    QmlPlugin {
        name: "QtGraphicalEffects"
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
}
