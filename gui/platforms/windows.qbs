import qbs

QtPlugin {
    condition: qbs.targetOS.contains("windows")
    category: "platforms"
    targetName: "qwindows"

    readonly property path basePath: configure.sourcePath + "/qtbase/src/plugins/platforms/windows"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    cpp.includePaths: [
        basePath,
    ].concat(base)

    cpp.defines: [
        "QT_NO_TABLETEVENT", // ### qwindowstabletsupport fails to find wintab.h (?)
    ].concat(base)

    cpp.dynamicLibraries: [
        "gdi32",
    ]

    Depends { name: "angle-gles2"; condition: configure.angle; required: false }
    Depends { name: "freetype" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp",
        ]
        excludeFiles: [
            "qwindowsglcontext.cpp", // ### fixme
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
