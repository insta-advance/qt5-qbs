import qbs

QmlPlugin {
    targetName: "qtquick2plugin"
    pluginPath: "QtQuick.2"
    files: project.sourceDirectory + "/qtdeclarative/src/imports/qtquick2/plugin.cpp"

    Depends { name: "QtQuick" }
}
