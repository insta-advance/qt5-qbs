import qbs

QtPlugin {
    targetName: name + "-integration"
    readonly property string basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/deviceintegration"

    category: "egldeviceintegrations"

    cpp.includePaths: base.concat(includePaths)

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    Depends { name: "egl" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtEglDeviceIntegration" }
}
