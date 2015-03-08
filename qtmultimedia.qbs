import qbs

QtModule {
    name: "QtMultimedia"
    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/multimedia"

    includeDependencies: ["QtCore-private", "QtNetwork", "QtGui", "QtQuick", "QtMultimedia-private"]

    cpp.defines: base.concat([
        "QT_BUILD_MULTIMEDIA_LIB",
        "QT_MULTIMEDIA_QAUDIO",
    ])

    Depends { name: "QtMultimediaHeaders" }
    Depends { name: "QtCore" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtGui" }
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
