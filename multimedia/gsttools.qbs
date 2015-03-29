import qbs

QtModule {
    id: gsttools
    name: "QtGstTools"
    condition: configure.gstreamer

    includeDependencies: ["QtCore-private", "QtNetwork", "QtGui", "QtQuick", "QtMultimedia-private"]

    Depends { name: "gstreamer" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimedia" }

    Group {
        name: "headers"
        prefix: project.sourcePath + "/qtmultimedia/src/multimedia/gsttools_headers/"
        files: [
            "*.h",
        ]
        excludeFiles: [
            "qgstreamergltexturerenderer_p.h", // ### fixme: includes an x header which needs a probe
            "qgstreamervideowidget_p.h",       // ### fixme: requires QtMultmediaWidgetsHeaders
            "qvideosurfacegstsink_p.h", // gst 0.1
            "qgstreamermirtexturerenderer_p.h", // mir
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtmultimedia/src/gsttools/"
        files: "*.cpp"
        excludeFiles: [
            "qgstreamergltexturerenderer.cpp", // ### fixme: see above
            "qgstreamervideowidget.cpp",       // ### fixme: see above
            "qvideosurfacegstsink.cpp", // gst 0.1
            "qgstreamermirtexturerenderer.cpp", // mir
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
