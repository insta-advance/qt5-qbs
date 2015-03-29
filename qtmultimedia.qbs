import qbs

Project {
    name: "QtMultimedia"

    Project {
        name: "tools"
        references: [
            "multimedia/gsttools.qbs",
            "multimedia/multimediaquicktools.qbs",
        ]
    }

    Project {
        name: "imports"
        references: [
            "multimedia/declarative_multimedia.qbs",
        ]
    }

    Project {
        name: "mediaservice"
        references: [
            "multimedia/mediaservice/gstreamer-camerabin.qbs",
        ]
    }

    Project {
        name: "video"
        references: [
            "multimedia/video/videonode-egl.qbs",
            "multimedia/video/videonode-imx6.qbs",
        ]
    }

    QtModule {
        id: qtmultimedia
        condition: configure.multimedia
        name: "QtMultimedia"

        readonly property path basePath: project.sourcePath + "/qtmultimedia/src/multimedia"

        includeDependencies: ["QtCore-private", "QtNetwork", "QtGui", "QtQuick", "QtMultimedia-private"]

        cpp.defines: [
            "QT_BUILD_MULTIMEDIA_LIB",
            "QT_MULTIMEDIA_QAUDIO",
        ].concat(base)

        Depends { name: "angle-gles2"; condition: configure.angle; required: false }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtMultimediaHeaders" }
        Depends { name: "QtNetwork" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }

        QtMultimediaHeaders {
            name: "headers"
            excludeFiles: {
                var excludeFiles = [
                    "qtmultimediaquicktools_headers/*.h", // moc'd by QtMultimediaTools
                    "gsttools_headers/*.h",               // moc'd by QtGstTools
                ];

                if (!configure.pulseaudio)
                    excludeFiles.push("audio/qsoundeffect_pulse_p.h");

                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: [
                "*.cpp",
                "audio/*.cpp",
                "camera/*.cpp",
                "controls/*.cpp",
                "playback/*.cpp",
                "qtmultimediaquicktools_headers/*.cpp",
                "radio/*.cpp",
                "video/*.cpp",
                "recording/*.cpp",
            ]
            excludeFiles: {
                var excludeFiles = [];

                if (!configure.pulseaudio)
                    excludeFiles.push("audio/qsoundeffect_pulse_p.cpp");

                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }
    }
}
