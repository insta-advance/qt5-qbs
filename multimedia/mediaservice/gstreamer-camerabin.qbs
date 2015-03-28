import qbs

QtPlugin {
    readonly property string basePath: configure.sourcePath + "/qtmultimedia/src/plugins/gstreamer/camerabin"

    condition: configure.gstreamer
    targetName: "gstcamerabin"
    category: "mediaservice"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtMultimedia-private"]

    Depends { name: "gstreamer" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtGstTools" }
    Depends { name: "QtMultimedia" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h",
        ]
        excludeFiles: [
            "camerabuttonlistener_meego.h",
            "camerabinfocus.h",
            "camerabinexposure.h",
            "camerabinflash.h",
            "camerabinlocks.h",
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
        excludeFiles: [
            "camerabuttonlistener_meego.cpp",
            "camerabinexposure.cpp",
            "camerabinflash.cpp",
            "camerabinfocus.cpp",
            "camerabinlocks.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
