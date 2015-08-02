import qbs

QtModule {
    id: gsttools
    name: "QtGstTools"
    condition: project.gstreamer

    Depends { name: "gstreamer" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "QtMultimedia" }

    Group {
        name: "headers"
        prefix: project.sourceDirectory + "/qtmultimedia/src/multimedia/gsttools_headers/"
        files: [
            "*.h",
        ]
        excludeFiles: [
            "qgstreamergltexturerenderer_p.h", // ### fixme: includes an x header which needs a probe
            "qgstreamervideowidget_p.h",       // ### fixme: requires QtMultmediaWidgetsHeaders
            "qvideosurfacegstsink_p.h", // gst 0.1
            "qgstreamermirtexturerenderer_p.h", // mir
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtmultimedia/src/gsttools/"
        files: "*.cpp"
        excludeFiles: [
            "qgstreamergltexturerenderer.cpp", // ### fixme: see above
            "qgstreamervideowidget.cpp",       // ### fixme: see above
            "qvideosurfacegstsink.cpp", // gst 0.1
            "qgstreamermirtexturerenderer.cpp", // mir
        ]
    }
}
