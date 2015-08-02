import qbs

QtPlugin {
    targetName: name + "-integration"
    readonly property string basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/xcb"

    category: "xcbglintegrations"

    cpp.includePaths: [
        basePath,
    ].concat(base)

    //Depends { name: "xcb-x11" }
    Depends { name: "qt-xcb" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "QtXcbQpa" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformSupport" }
}
