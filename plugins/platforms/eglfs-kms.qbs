import qbs

QtEglDeviceIntegrationPlugin {
    condition: project.eglfs_kms

    Depends { name: "libdrm" }
    Depends { name: "gbm" }

    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS",
    ].concat(base)

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_kms/"
        files: [
            "qeglfskmscursor.h", // ### QT_NO_CURSOR
        ]
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
    }
}
