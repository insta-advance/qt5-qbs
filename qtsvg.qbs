import qbs

Project {
    name: "QtSvg"

    references: [
        "svg/imageformats/svg.qbs",
    ]

    QtModule {
        name: "QtSvg"
        condition: configure.svg
        readonly property path basePath: configure.sourcePath + "/qtsvg/src/svg"

        includeDependencies: ["QtCore-private", "QtGui-private", "QtWidgets-private"]

        Depends { name: "zlib" }
        Depends { name: "QtSvgHeaders" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtWidgets"; condition: configure.widgets }

        QtSvgHeaders {
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