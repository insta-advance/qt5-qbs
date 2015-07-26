import qbs

QtPlugin {
    targetName: name + "-integration"
    readonly property string basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/deviceintegration"

    category: "egldeviceintegrations"

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs",
    ].concat(base)

    Depends { name: "egl" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtEglDeviceIntegration" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformSupport" }
}
