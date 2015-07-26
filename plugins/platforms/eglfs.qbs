import qbs

Project {
    references: "eglfs-integration.qbs"

    QtPlugin {
        condition: project.eglfs
        category: "platforms"
        targetName: "qeglfs"

        cpp.defines: {
            var defines = base;
            if (project.eglfs_viv) {
                defines.push("LINUX");
                defines.push("EGL_API_FB");
            }
            return defines;
        }

        Depends { name: "egl" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtEglDeviceIntegration" }
        Depends { name: "QtCoreHeaders" }
        Depends { name: "QtGuiHeaders" }
        Depends { name: "QtPlatformHeaders" }
        Depends { name: "QtPlatformSupport" }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/"
            files: "qeglfsmain.cpp"
        }
    }

    SubProject {
        filePath: "eglfs-kms.qbs"
    }

    SubProject {
        filePath: "eglfs-viv.qbs"
    }

    SubProject {
        filePath: "eglfs-x11.qbs"
    }
}
