import qbs

QtEglDeviceIntegrationPlugin {
    condition: configure.egl && configure.xcb

    cpp.defines: base.concat([
        "MESA_EGL_NO_X11_HEADERS", // for Mesa
        "EGL_API_FB",              // for Vivante
    ])

    Depends { name: "xcb-x11" }

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_x11/"
        files: [
            "*.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/eglfs_x11/"
        files: [
            "*.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
