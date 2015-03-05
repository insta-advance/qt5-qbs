import qbs

Project {
    QtModule {
        name: "QtMultimediaQuickTools"

        includeDependencies: ["QtCore", "QtMultimedia-private"]

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQuick" }
        Depends { name: "QtMultimedia" }

        Group {
            name: "headers"
            prefix: project.sourceDirectory + "/qtmultimedia/src/"
            files: [
                "multimedia/qtmultimediaquicktools_headers/*.h",
                "qtmultimediaquicktools/*.h",
            ]
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtmultimedia/src/qtmultimediaquicktools/"
            files: "*.cpp"
            fileTags: "moc"
            overrideTags: false
        }
    }

    QtModule {
        name: "QtGstTools"

        includeDependencies: ["QtCore-private", "QtNetwork", "QtGui", "QtQuick", "QtMultimedia-private"]

        cpp.cxxFlags: {
            var cxxFlags = base;

            if (QtHost.config.gstreamer)
                Array.prototype.push.apply(cxxFlags, QtHost.config.gstreamerProbe.cflags);

            return cxxFlags;
        }

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
            ]
            fileTags: "moc"
            overrideTags: false
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
            fileTags: "moc"
            overrideTags: false
        }
    }


    SubProject {
        Properties { condition: true/*fixme*/ }
        filePath: "videonode-imx6.qbs"
    }

    SubProject {
        Properties { condition: true/*fixme*/ }
        filePath: "videonode-egl.qbs"
    }
}
