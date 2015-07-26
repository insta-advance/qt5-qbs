import qbs
import qbs.File

Project {
    name: "QtSvg"
    condition: File.exists(project.sourceDirectory + "/qtsvg")

    references: [
        "plugins/imageformats/svg.qbs",
    ]

    QtModule {
        name: "QtSvg"
        condition: project.svg !== false
        readonly property path basePath: project.sourceDirectory + "/qtsvg/src/svg"

        cpp.defines: [
            "QT_BUILD_SVG_LIB",
        ].concat(base)

        Depends { name: "zlib" }
        Depends { name: "QtSvgHeaders" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtWidgets"; condition: project.widgets }

        QtSvgHeaders {
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
}
