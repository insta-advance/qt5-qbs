import qbs

QtEglDeviceIntegrationPlugin {
    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS", // for Mesa
        "EGL_API_FB",              // for Vivante
    ]

    cpp.dynamicLibraries: base.concat(x11DynamicLibraries)

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
