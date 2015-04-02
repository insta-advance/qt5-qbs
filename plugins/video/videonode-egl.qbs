import qbs

QtPlugin {
    category: "video/videonode"
    condition: configure.egl && configure.opengl == "es2"

    includeDependencies: [
        "QtCore-private",
        "QtGui-private",
        "QtMultimedia-private",
        "QtPlatformSupport-private",
        "QtQuick-private",
    ]

    cpp.defines: {
        var defines = base;
        if (configure.imx6) {
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
        files: project.sourcePath + "/qtmultimedia/src/plugins/videonode/egl/*.h"
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        files: project.sourcePath + "/qtmultimedia/src/plugins/videonode/egl/*.cpp"
        fileTags: "moc"
        overrideTags: false
    }
}
