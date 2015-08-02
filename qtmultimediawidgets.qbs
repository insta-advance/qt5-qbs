import qbs
import "headers/QtMultimediaWidgetsHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    name: "QtMultimediaWidgets"
    condition: project.multimediawidgets
    simpleName: "multimediawidgets"
    prefix: project.sourceDirectory + "/qtmultimedia/src/multimediawidgets/"

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
        Depends { name: "Qt.widgets" }
        Depends { name: "Qt.multimedia" }

        cpp.defines: [
            "QT_BUILD_MULTIMEDIAWIDGETS_LIB",
            "QT_NO_OPENGL", // needs porting to QtGui's version of OpenGL
        ].concat(base)

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders {
            excludeFiles: [
                "qeglimagetexturesurface_p.h", // QtOpenGL
            ]
        }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "*.cpp",
            ]
            excludeFiles: [
                "qeglimagetexturesurface.cpp", // QtOpenGL
                "qgraphicsvideoitem_maemo6.cpp", // maemo
            ]
        }
    }
}
