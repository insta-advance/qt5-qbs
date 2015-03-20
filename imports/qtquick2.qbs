import qbs

QmlPlugin {
    readonly property path basePath: project.sourcePath + "/qtdeclarative/src/imports/qtquick2"
    targetName: "qtquick2plugin"
    pluginPath: "QtQuick.2"

    includeDependencies: ["QtQuick-private"]

    Depends { name: "QtCore" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: "plugin.cpp"
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "qml"
        prefix: basePath + "/"
        files: "qmldir"
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
