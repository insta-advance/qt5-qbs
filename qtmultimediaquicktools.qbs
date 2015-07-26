import qbs

QtModule {
    name: "QtMultimediaQuickTools"
    targetName: "Qt5MultimediaQuick_p"

    cpp.defines: [
        "QT_BUILD_QTMM_QUICK_LIB",
    ].concat(base)

    Depends { name: "gl"; condition: project.opengl }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtQuick" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtQuickHeaders" }
    Depends { name: "QtMultimediaHeaders" }

    Group {
        name: "headers"
        prefix: project.sourceDirectory + "/qtmultimedia/src/"
        files: [
            "multimedia/qtmultimediaquicktools_headers/*.h",
            "qtmultimediaquicktools/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtmultimedia/src/qtmultimediaquicktools/"
        files: [
            "qdeclarativevideooutput.cpp",
            "qdeclarativevideooutput_render.cpp",
            "qdeclarativevideooutput_window.cpp",
            "qsgvideonode_p.cpp",
            "qsgvideonode_rgb.cpp",
            "qsgvideonode_texture.cpp",
            "qsgvideonode_yuv.cpp",
            "qtmultimediaquicktools.qrc",
        ]
    }
}
