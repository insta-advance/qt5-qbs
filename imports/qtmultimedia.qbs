import qbs

QmlPlugin {
    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/imports/multimedia"
    targetName: "declarative_multimedia"
    pluginPath: "QtMultimedia"

    includeDependencies: ["QtCore", "QtQml", "QtMultimedia-private"]

    Depends { name: "QtCore" }
    Depends { name: "QtQml" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtMultimediaQuickTools" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h"
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp"
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "qml"
        prefix: basePath + "/"
        files: [
            "qmldir",
            "*.qml"
        ]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
