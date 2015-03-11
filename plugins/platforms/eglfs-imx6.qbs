import qbs

QtEglDeviceIntegrationPlugin {
    condition: configure.imx6

    cpp.defines: base.concat([
        "EGL_API_FB",
    ])

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
