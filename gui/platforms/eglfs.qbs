import qbs

Project {
    references: "eglfs-integration.qbs"

    QtPlugin {
        condition: configure.egl && qbs.targetOS.contains("linux")
        category: "platforms"
        targetName: "qeglfs"

        includeDependencies: ["QtCore", "QtGui-private", "QtPlatformSupport-private"]

        Depends { name: "egl" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtEglDeviceIntegration" }

        Group {
            name: "sources"
            prefix: project.sourcePath + "/qtbase/src/plugins/platforms/eglfs/"
            files: "qeglfsmain.cpp"
            fileTags: "moc"
            overrideTags: false
        }
    }

    SubProject {
        filePath: "eglfs-imx6.qbs"
    }

    SubProject {
        filePath: "eglfs-kms.qbs"
    }

    SubProject {
        filePath: "eglfs-x11.qbs"
    }
}
