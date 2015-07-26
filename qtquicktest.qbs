import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtQuickTest"

    QtModule {
        name: "QtQuickTest"
        simpleName: "qmltest"
        condition: project.qmltest !== false

        readonly property path basePath: project.sourceDirectory + "/qtdeclarative/src/qmltest"

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
        }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: [
                "*.cpp",
            ]
        }
    }

    Project {
        name: "imports"
        QmlPlugin {
            condition: project.qmltest !== false
            targetName: "qmltestplugin"
            pluginPath: "QtTest"

            readonly property string basePath: project.sourceDirectory + "/qtdeclarative/src/imports/testlib"

            Depends { name: "QtCore" }
            Depends { name: "QtGui" }
            Depends { name: "QtQml" }
            Depends { name: "QtTest" }
            Depends { name: "QtQuickTest" }

            Group {
                name: "sources"
                prefix: basePath + "/"
                files: "main.cpp"
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
