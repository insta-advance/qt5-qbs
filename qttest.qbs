import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtTest"

    QtModule {
        name: "QtTest"
        simpleName: "testlib"
        condition: configure.testlib !== false

        readonly property path basePath: project.sourcePath + "/qtbase/src/testlib"

        includeDependencies: ["QtCore-private", "QtTest-private"]

        cpp.defines: [
            "QT_GUI_LIB",
        ].concat(base)

        Depends { name: "QtTestHeaders" }
        Depends { name: "QtCore" }

        QtTestHeaders {
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
