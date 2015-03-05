import qbs

QtPlugin {
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/videonode/imx6"

    category: "video"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

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
        overrideTags: true
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp",
        ]
        fileTags: "moc"
        overrideTags: true
    }
}
