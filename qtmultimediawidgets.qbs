import qbs

Project {
    name: "QtMultimediaWidgets"

    QtModule {
        condition: project.multimedia !== false && project.widgets && project.multimediawidgets !== false
        name: "QtMultimediaWidgets"

        readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/multimediawidgets"

        cpp.defines: [
            "QT_BUILD_MULTIMEDIAWIDGETS_LIB",
            "QT_NO_OPENGL", // needs porting to QtGui's version of OpenGL
        ].concat(base)

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtWidgets" }
        Depends { name: "QtMultimedia" }
        Depends { name: "QtMultimediaWidgetsHeaders" }

        QtMultimediaWidgetsHeaders {
            name: "headers"
            excludeFiles: [
                "doc/**",
                "qeglimagetexturesurface_p.h", // QtOpenGL
            ]
        }

        Group {
            name: "sources"
            prefix: basePath + "/"
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
