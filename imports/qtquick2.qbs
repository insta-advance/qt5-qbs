import qbs

QmlPlugin {
    targetName: "qtquick2plugin"
    pluginPath: "QtQuick.2"

    includeDependencies: ["QtQuick-private"]

    Depends { name: "QtCore" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }

    Group {
        name: "sources"
        files: project.sourceDirectory + "/qtdeclarative/src/imports/qtquick2/plugin.cpp"
        fileTags: "moc"
        overrideTags: false
    }
}
