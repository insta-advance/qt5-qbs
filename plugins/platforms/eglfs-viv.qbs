import qbs

QtEglDeviceIntegrationPlugin {
    condition: project.eglfs_viv

    cpp.defines: [
        "LINUX",
        "EGL_API_FB",
    ].concat(base)

    Group {
        name: "headers"
        prefix: basePath + "/eglfs_viv/"
        files: [
            "*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: basePath + "/eglfs_viv/"
        files: [
            "*.cpp",
        ]
    }
}
