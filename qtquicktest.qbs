import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtQuickTest"

    QtModule {
        name: "QtQuickTest"
        simpleName: "qmltest"
        condition: configure.qmltest !== false

        readonly property path basePath: project.sourcePath + "/qtdeclarative/src/qmltest"

        includeDependencies: ["QtCore-private", "QtGui", "QtQml-private", "QtQuick", "QtQuickTest-private", "QtTest-private"]

        cpp.defines: [
            "QT_QUICKTEST_LIB", "QT_GUI_LIB",
        ].concat(base)

        Depends { name: "QtQuickTestHeaders" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }
        Depends { name: "QtTest" }

        QtQuickTestHeaders {
            name: "headers"
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: [
                "*.cpp",
            ]
            fileTags: "moc"
            overrideTags: false
        }
    }

    Project {
        name: "imports"
        QmlPlugin {
            condition: configure.qmltest !== false
            targetName: "qmltestplugin"
            pluginPath: "QtTest"

            readonly property string basePath: project.sourcePath + "/qtdeclarative/src/imports/testlib"

            includeDependencies: ["QtCore-private", "QtQml-private", "QtQuickTest-private"]

            Depends { name: "QtCore" }
            Depends { name: "QtGui" }
            Depends { name: "QtQml" }
            Depends { name: "QtTest" }
            Depends { name: "QtQuickTest" }

            Group {
                name: "sources"
                prefix: basePath + "/"
                files: "main.cpp"
                fileTags: "moc"
                overrideTags: false
            }

            Group {
                name: "qml"
                prefix: basePath + "/"
                files: ["qmldir", "*.qml", "*.js"]
                qbs.install: true
                qbs.installDir: "qml/" + pluginPath
            }
        }
    }
}
