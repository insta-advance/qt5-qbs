import qbs
import qbs.Probes

QtPlugin {
    category: "video/videonode"
    condition: project.eglfs_viv
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/videonode/imx6"

    cpp.defines: [
        "LINUX",
        "EGL_API_FB",
    ].concat(base)

    Depends { name: "opengl" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtMultimediaQuickTools" }
    Depends { name: "Qt.quick" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp",
        ]
    }
}
