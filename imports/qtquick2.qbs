import qbs

QmlPlugin {
    targetName: "qtquick2plugin"
    pluginPath: "QtQuick.2"

    Group {
        name: "sources"
        files: project.sourceDirectory + "/qtdeclarative/src/imports/qtquick2/plugin.cpp"
        fileTags: "moc_cpp"
        overrideTags: false
    }

    Depends { name: "QtCore" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }
}
