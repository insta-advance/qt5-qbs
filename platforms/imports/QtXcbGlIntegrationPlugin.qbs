import qbs

QtPlugin {
    targetName: name + "-integration"
    readonly property string basePath: project.sourcePath + "/qtbase/src/plugins/platforms/xcb"

    category: "xcbglintegrations"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    cpp.includePaths: base.concat(basePath)

    //Depends { name: "xcb-x11" }
    Depends { name: "qt-xcb" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtXcbQpa" }
}
