import qbs

QtEglfsDeviceIntegrationPlugin {
    condition: x11DynamicLibraries.length // ### Creator workaround
    cpp.defines: [
        "EGL_API_FB",
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
