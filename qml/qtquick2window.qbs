import qbs

QmlPlugin {
    readonly property path basePath: project.sourceDirectory + "/qtdeclarative/src/imports/window/"

    targetName: "windowplugin"
    pluginPath: "QtQuick/Window.2"

    Depends { name: "QtCore" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtQmlHeaders" }
    Depends { name: "QtQuickHeaders" }

    Group {
        name: "sources"
        prefix: basePath
        files: "plugin.cpp"
    }

    Group {
        name: "qml"
        prefix: basePath
        files: "qmldir"
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }
}
