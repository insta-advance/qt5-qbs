import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtQuickTest"

    QtModule {
        name: "QtQuickTest"
        simpleName: "qmltest"
        condition: configure.qmltest

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
}
