import qbs
import qbs.Probes

QtEglDeviceIntegrationPlugin {
    condition: configure.kms

    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS",
    ].concat(base)

    Depends { name: "kms" }

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_kms/"
        files: [
            "qeglfskmscursor.h", // ### QT_NO_CURSOR
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/eglfs_kms/"
        files: [
            "qeglfskmscursor.cpp", // ### QT_NO_CURSOR
            "qeglfskmsdevice.cpp",
            "qeglfskmsdevice.h",
            "qeglfskmsintegration.cpp",
            "qeglfskmsintegration.h",
            "qeglfskmsmain.cpp",
            "qeglfskmsscreen.cpp",
            "qeglfskmsscreen.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
