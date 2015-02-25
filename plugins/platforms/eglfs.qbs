import qbs
import qbs.Probes

Project {
    QtPlugin {
        category: "platforms"

        QtHost.includes.modules: [ "core-private", "gui-private", "platformsupport-private" ]

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtEglDeviceIntegration" }

        cpp.dynamicLibraries: [ "EGL", "GLESv2" ]
        cpp.defines: [ "MESA_EGL_NO_X11_HEADERS" ]

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/"
            files: "qeglfsmain.cpp"
            fileTags: "moc_cpp"
            overrideTags: false
        }

        Group {
            name: "sources_cursor"
            condition: QtHost.config.cursor
            prefix: project.sourceDirectory + "/qtbase/src/"
            files: [
                "platformsupport/eglconvenience/qeglplatformcursor.cpp",
                "plugins/platforms/eglfs/cursor.qrc",
            ]
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


