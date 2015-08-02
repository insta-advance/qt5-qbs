import qbs

QmlPlugin {
    readonly property path basePath: project.sourceDirectory + "/qtdeclarative/src/imports/qtquick2/"

    targetName: "qtquick2plugin"
    pluginPath: "QtQuick.2"

    Depends { name: "Qt.core" }
    Depends { name: "Qt.qml" }
    Depends { name: "Qt.quick" }
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
