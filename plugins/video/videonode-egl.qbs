import qbs

QtPlugin {
    category: "video/videonode"
    condition: project.egl && project.opengl == "es2"

    cpp.defines: {
        var defines = base;
        if (project.eglfs_viv) {
            defines.push("LINUX");
            defines.push("EGL_API_FB");
        }
        return defines;
    }

    Depends { name: "egl" }
    Depends { name: "opengl" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtMultimediaQuickTools" }
    Depends { name: "QtQuick" }

    Group {
        name: "headers"
        files: project.sourceDirectory + "/qtmultimedia/src/plugins/videonode/egl/*.h"
    }

    Group {
        name: "sources"
        files: project.sourceDirectory + "/qtmultimedia/src/plugins/videonode/egl/*.cpp"
    }
}
