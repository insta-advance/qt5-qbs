import qbs
import qbs.Probes

Project {
    QtPlugin {
        category: "platforms"
        targetName: "qeglfs"

        includeDependencies: ["QtCore", "QtGui-private", "QtPlatformSupport-private"]

        cpp.dynamicLibraries: [ "EGL", "GLESv2" ]
        cpp.defines: [ "MESA_EGL_NO_X11_HEADERS" ]

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtEglDeviceIntegration" }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/"
            files: "qeglfsmain.cpp"
            fileTags: "moc"
            overrideTags: false
        }
    }

    SubProject {
        filePath: "eglfs-integration.qbs"
    }

    SubProject {
        //condition: QtHost.config.kms
        filePath: "eglfs-kms.qbs"
    }
}


