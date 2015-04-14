import qbs

QmlPlugin {
    readonly property path basePath: project.sourcePath + "/qtdeclarative/src/imports/window"
    condition: configure.quick !== false
    targetName: "windowplugin"
    pluginPath: "QtQuick/Window.2"

    includeDependencies: ["QtQml-private", "QtQuick-private"]

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
