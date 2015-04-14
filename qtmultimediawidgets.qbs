import qbs

Project {
    name: "QtMultimediaWidgets"

    QtModule {
        condition: configure.multimedia !== false && configure.widgets && configure.multimediawidgets !== false
        name: "QtMultimediaWidgets"

        readonly property path basePath: project.sourcePath + "/qtmultimedia/src/multimediawidgets"

        includeDependencies: ["QtCore", "QtGui", "QtWidgets", "QtMultimedia-private", "QtMultimediaWidgets-private"]

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
            fileTags: "moc"
            excludeFiles: [
                "doc/**",
                "qeglimagetexturesurface_p.h", // QtOpenGL
            ]
            overrideTags: false
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
            fileTags: "moc"
            overrideTags: false
        }
    }
}
