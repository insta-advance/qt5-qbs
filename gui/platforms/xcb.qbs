import qbs
import qbs.Probes

Project {
    references: [
        "xcb-integration.qbs",
        "xcb-egl.qbs",
    ]

    QtPlugin {
        condition: configure.xcb && configure.egl && qbs.targetOS.contains("linux")
        category: "platforms"
        targetName: "qxcb"

        readonly property path basePath: configure.sourcePath + "/qtbase/src/plugins/platforms/xcb"

        includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

        cpp.includePaths: [
            basePath,
        ].concat(base)

        Depends { name: "egl" }
        //Depends { name: "xcb-x11" }
        Depends { name: "qt-xcb" }
        Depends { name: "xkbcommon" }
        //Depends { name: "xkb-x11"; condition: configure.xkb }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtXcbQpa" }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: "qxcbmain.cpp"
            fileTags: "moc"
            overrideTags: false
        }
    }
}
