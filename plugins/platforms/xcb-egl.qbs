import qbs

QtXcbGlIntegrationPlugin {
    condition: project.xcb && project.egl

    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS",
    ].concat(base)

    cpp.includePaths: [
        basePath + "/gl_integrations",
    ].concat(base)

    Depends { name: "egl" }
    Depends { name: "gl"; condition: project.opengl }

    Group {
        name: "headers"
        prefix: basePath + "/gl_integrations/xcb_egl/"
        files: [
            "*.h",
            "",
        ]
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
    }
}
