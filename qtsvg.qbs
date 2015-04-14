import qbs
import qbs.File

Project {
    name: "QtSvg"
    condition: File.exists(project.sourcePath + "/qtsvg")

    references: [
        "plugins/imageformats/svg.qbs",
    ]

    QtModule {
        name: "QtSvg"
        condition: configure.svg !== false
        readonly property path basePath: project.sourcePath + "/qtsvg/src/svg"

        includeDependencies: {
            var includeDependencies = ["QtCore-private", "QtGui-private", "QtSvg-private"];
            if (configure.widgets)
                includeDependencies.push("QtWidgets-private");
            return includeDependencies;
        }

        cpp.defines: {
            var defines = base;
            if (!configure.widgets)
                defines.push("QT_NO_WIDGETS");
            return defines;
        }

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
