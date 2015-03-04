import qbs

QtModule {
    name: "QtMultimedia"
    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/multimedia"

    includeDependencies: ["QtCore-private", "QtNetwork", "QtGui", "QtQuick", "QtMultimedia-private"]

    cpp.defines: base.concat([
        "QT_BUILD_MULTIMEDIA_LIB",
        "QT_MULTIMEDIA_QAUDIO",
    ])

    cpp.cxxFlags: {
        var cxxFlags = base;

        if (QtHost.config.gstreamer)
            Array.prototype.push.apply(cxxFlags, QtHost.config.gstreamerProbe.cflags);

        return cxxFlags;
    }

    cpp.includePaths: {
        var includePaths = base;

        if (QtHost.config.gstreamer)
            includePaths.push(basePath + "/gsttools_headers");

        return includePaths;
    }

    Depends { name: "QtMultimediaHeaders" }
    Depends { name: "QtCore" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtGui" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }

    QtMultimediaHeaders {
        name: "headers"
        excludeFiles: {
            var excludeFiles = [];

            if (QtHost.config.gstreamer) {
                excludeFiles.push("gsttools_headers/qgstreamervideowidget_p.h"); // widgets
                excludeFiles.push("gsttools_headers/qvideosurfacegstsink_p.h"); // gst 0.1

                if (!QtHost.config.x11)
                    excludeFiles.push("gsttools_headers/qgstreamergltexturerenderer_p.h");
            } else {
                excludeFiles.push("gsttools_headers/*.h");
            }

            if (!QtHost.config.pulseaudio)
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

            if (!QtHost.config.pulseaudio)
                excludeFiles.push("audio/qsoundeffect_pulse_p.cpp");

            return excludeFiles;
        }
        fileTags: "moc"
        overrideTags: false
    }
}
