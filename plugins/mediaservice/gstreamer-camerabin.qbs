import qbs

QtPlugin {
    readonly property string basePath: project.sourceDirectory + "/qtmultimedia/src/plugins/gstreamer/camerabin"

    condition: project.gstreamer
    targetName: "gstcamerabin"
    category: "mediaservice"

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
    }
}
