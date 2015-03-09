import qbs

QtPlugin {
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/videonode/egl"

    category: "video"

    includeDependencies: [
        "QtCore-private",
        "QtGui-private",
        "QtPlatformSupport-private",
        "QtQuick-private",
    ]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimediaQuickTools" }

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
