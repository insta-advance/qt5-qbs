import qbs

QtEglDeviceIntegrationPlugin {
    condition: configure.imx6

    cpp.defines: [
        "EGL_API_FB",
    ].concat(base)

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_viv/"
        files: [
            "*.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/eglfs_viv/"
        files: [
            "*.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
