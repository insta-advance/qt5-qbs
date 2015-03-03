import qbs

QtModule {
    name: "QtMultimedia"
    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/multimedia"

    includeDependencies: ["QtCore", "QtNetwork", "QtQuick", "QtMultimedia-private"]

    cpp.defines: base.concat([
        "QT_BUILD_MULTIMEDIA_LIB",
    ])

    cpp.cxxFlags: {
        var cxxFlags = [];

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
    Depends { name: "QtGui" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
        prefix: basePath + "/"
        fileTags: "moc_hpp_p"
        files: [
            "qmediaobject.h",
            "audio/qaudiodecoder.h",
            "camera/qcameraexposure.h",
            "camera/qcamera.h",
            "camera/qcameraimagecapture.h",
            "playback/qmedianetworkplaylistprovider_p.h",
            "playback/qmediaplayer.h",
            "playback/qmediaplaylist.h",
            "playback/qmediaplaylistnavigator_p.h",
            "playback/qmediaplaylistprovider_p.h",
            "playback/playlistfileparser_p.h",
            "radio/qradiodata.h",
            "recording/qmediarecorder.h",
        ]
    }

    QtMultimediaHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: {
            var excludeFiles = headers_moc_p.files;

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
    }

    Group {
        id: sources_moc
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
        ]
        fileTags: "moc_cpp"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
        ]
    }
}
