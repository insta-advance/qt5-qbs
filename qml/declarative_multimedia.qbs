import qbs

QmlPlugin {
    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/imports/multimedia"
    condition: project.multimedia !== false
    pluginPath: "QtMultimedia"

    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "Qt.qml" }
    Depends { name: "Qt.quick" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtQmlHeaders" }
    Depends { name: "QtQuickHeaders" }
    Depends { name: "QtMultimediaHeaders" }
    Depends { name: "QtMultimediaQuickTools" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h"
        ]
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "multimedia.cpp",
            "qdeclarativeaudio.cpp",
            "qdeclarativecamera.cpp",
            "qdeclarativecameracapture.cpp",
            "qdeclarativecameraexposure.cpp",
            "qdeclarativecameraflash.cpp",
            "qdeclarativecamerafocus.cpp",
            "qdeclarativecameraimageprocessing.cpp",
            "qdeclarativecamerapreviewprovider.cpp",
            "qdeclarativecamerarecorder.cpp",
            "qdeclarativecameraviewfinder.cpp",
            "qdeclarativemultimediaglobal.cpp",
            "qdeclarativeradio.cpp",
            "qdeclarativeradiodata.cpp",
            "qdeclarativetorch.cpp",
        ]
    }

    Group {
        name: "qml"
        prefix: basePath + "/"
        files: [
            "plugins.qmltypes",
            "qmldir",
            "Video.qml",
        ]
        fileTags: "qml"
    }
}
