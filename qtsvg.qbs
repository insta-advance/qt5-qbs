import qbs
import "headers/QtSvgHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    condition: project.svg
    name: "QtSvg"
    simpleName: "svg"
    prefix: project.sourceDirectory + "/qtsvg/src/svg/"

    references: [
        "plugins/imageformats/svg.qbs",
    ]

    Product {
        name: module.privateName
        profiles: project.targetProfiles
        type: "hpp"
        Depends { name: module.moduleName }
        Export {
            Depends { name: "cpp" }
            cpp.defines: module.defines
            cpp.includePaths: module.includePaths
        }
    }

    QtHeaders {
        name: module.headersName
        sync.module: module.name
        ModuleHeaders { fileTags: "header_sync" }
    }

    QtModule {
        name: module.moduleName
        targetName: module.targetName

        Export {
            Depends { name: "cpp" }
            cpp.includePaths: module.publicIncludePaths
        }

        Depends { name: module.headersName }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.widgets"; condition: project.widgets }

        Depends { name: "zlib" }

        cpp.defines: [
            "QT_BUILD_SVG_LIB",
        ].concat(base)

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders { }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "*.cpp",
            ]
        }
    }
}
