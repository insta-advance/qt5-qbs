import qbs

QtEglDeviceIntegrationPlugin {
    condition: project.eglfs_x11

    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS", // for Mesa
        "EGL_API_FB",              // for Vivante
    ].concat(base)

    //Depends { name: "x11" }

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_x11/"
        files: [
            "*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: basePath + "/eglfs_x11/"
        files: [
            "*.cpp",
        ]
    }
}
