import qbs
import qbs.Probes

Project {
    references: [
        "xcb-integration.qbs",
        "xcb-egl.qbs",
    ]

    QtPlugin {
        condition: project.xcb && project.egl && qbs.targetOS.contains("linux")
        category: "platforms"
        targetName: "qxcb"

        readonly property path basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/xcb"

        cpp.includePaths: [
            basePath,
        ].concat(base)

        Depends { name: "egl" }
        //Depends { name: "xcb-x11" }
        Depends { name: "qt-xcb" }
        Depends { name: "xkbcommon" }
        //Depends { name: "xkb-x11"; condition: project.xkb }
        Depends { name: "QtGuiHeaders" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtXcbQpa" }

        Group {
            name: "sources"
            prefix: basePath + "/"
            files: "qxcbmain.cpp"
        }
    }
}
