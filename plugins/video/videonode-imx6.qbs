import qbs
import qbs.Probes

QtPlugin {
    readonly property string basePath: project.sourcePath + "/qtmultimedia/src/plugins/videonode/imx6"

    category: "video"
    condition: configure.imx6

    includeDependencies: [
        "QtCore-private",
        "QtGui-private",
        "QtMultimedia-private",
        "QtPlatformSupport-private",
        "QtQuick-private",
    ]

    Depends { name: "opengl" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtMultimediaQuickTools" }
    Depends { name: "QtQuick" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h",
        ]
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
