import qbs

QtXcbGlIntegrationPlugin {
    condition: configure.xcb && configure.egl

    cpp.defines: base.concat([
        "MESA_EGL_NO_X11_HEADERS",
    ])

    cpp.includePaths: base.concat([
        basePath + "/gl_integrations",
    ])

    Depends { name: "egl" }
    Depends { name: "opengl" }

    Group {
        name: "headers"
        prefix: basePath + "/gl_integrations/xcb_egl/"
        files: [
            "*.h",
            "",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/gl_integrations/xcb_egl/"
        files: [
            "*.cpp",
            "../../../../../platformsupport/eglconvenience/qeglplatformcontext.cpp",
            "../../../../../platformsupport/eglconvenience/qeglpbuffer.cpp",
            "../../../../../platformsupport/eglconvenience/qeglconvenience.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
