import qbs
import qbs.File
import qbs.Probes

Project {
    name: "QtTest"

    QtModule {
        name: "QtTest"
        condition: configure.testlib

        readonly property path basePath: project.sourcePath + "/qtbase/src/testlib"

        includeDependencies: ["QtCore-private", "QtTest-private"]

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
