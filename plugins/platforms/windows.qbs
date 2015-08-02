import qbs

QtPlugin {
    condition: project.gui && qbs.targetOS.contains("windows")
    category: "platforms"
    targetName: "qwindows"

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/windows/"

    cpp.dynamicLibraries: [
        "gdi32",
    ].concat(base)

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/3rdparty/wintab",
    ].concat(base)

    Depends { name: "angle-egl"; condition: project.egl }
    Depends { name: "angle-gles2"; condition: project.angle }
    Depends { name: "freetype" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformSupport" }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "main.cpp",
            "qwindowsbackingstore.cpp",
            "qwindowsclipboard.cpp",
            "qwindowscontext.cpp",
            "qwindowscursor.cpp",
            "qwindowsdialoghelpers.cpp",
            "qwindowsdrag.cpp",
            "qwindowsfontdatabase.cpp",
            "qwindowsfontdatabase_ft.cpp",
            "qwindowsfontengine.cpp",
            "qwindowsfontenginedirectwrite.cpp",
            "qwindowsgdiintegration.cpp",
            "qwindowsgdinativeinterface.cpp",
            "qwindowsglcontext.cpp",
            "qwindowsguieventdispatcher.cpp",
            "qwindowsinputcontext.cpp",
            "qwindowsintegration.cpp",
            "qwindowsinternalmimedata.cpp",
            "qwindowskeymapper.cpp",
            "qwindowsmime.cpp",
            "qwindowsmousehandler.cpp",
            "qwindowsnativeimage.cpp",
            "qwindowsnativeinterface.cpp",
            "qwindowsole.cpp",
            "qwindowsopengltester.cpp",
            "qwindowsscaling.cpp",
            "qwindowsscreen.cpp",
            "qwindowsservices.cpp",
            "qwindowssessionmanager.cpp",
            "qwindowstabletsupport.cpp",
            "qwindowstheme.cpp",
            "qwindowswindow.cpp",
        ]
    }

    Group {
        name: "sources_egl"
        condition: project.egl
        prefix: basePath
        files: [
            "qwindowseglcontext.cpp",
        ]
    }
}
