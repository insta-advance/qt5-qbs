import qbs

QmlPlugin {
    readonly property path basePath: project.sourcePath + "/qtmultimedia/src/imports/multimedia"
    pluginPath: "QtMultimedia"

    includeDependencies: ["QtCore", "QtQml", "QtMultimedia-private"]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }
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
