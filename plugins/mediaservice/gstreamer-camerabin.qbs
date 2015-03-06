import qbs

QtPlugin {
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/gstreamer/camerabin"

    targetName: "gstcamerabin"
    category: "video"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtMultimedia-private"]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtGstTools" }
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
