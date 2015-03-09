import qbs

QtPlugin {
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/gstreamer/camerabin"

    condition: configure.gstreamer
    targetName: "gstcamerabin"
    category: "mediaservice"

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
