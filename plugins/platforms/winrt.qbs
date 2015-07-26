import qbs

QtPlugin {
    condition: project.winrt
    category: "platforms"
    targetName: "qwinrt"

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/winrt/"

    Depends { name: "angle-egl" }
    Depends { name: "angle-glesv2" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtGuiHeaders" }

    Group {
        name: "headers"
        prefix: basePath
        files: [
            "qwinrtbackingstore.h",
            "qwinrtcursor.h",
            "qwinrteglcontext.h",
            "qwinrteventdispatcher.h",
            "qwinrtfiledialoghelper.h",
            "qwinrtfileengine.h",
            "qwinrtfontdatabase.h",
            "qwinrtinputcontext.h",
            "qwinrtintegration.h",
            "qwinrtmessagedialoghelper.h",
            "qwinrtscreen.h",
            "qwinrtservices.h",
            "qwinrttheme.h",
            "qwinrtwindow.h",
        ]
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "main.cpp",
            "qwinrtbackingstore.cpp",
            "qwinrtcursor.cpp",
            "qwinrteglcontext.cpp",
            "qwinrteventdispatcher.cpp",
            "qwinrtfiledialoghelper.cpp",
            "qwinrtfileengine.cpp",
            "qwinrtfontdatabase.cpp",
            "qwinrtinputcontext.cpp",
            "qwinrtintegration.cpp",
            "qwinrtmessagedialoghelper.cpp",
            "qwinrtscreen.cpp",
            "qwinrtservices.cpp",
            "qwinrttheme.cpp",
            "qwinrtwindow.cpp",
        ]
    }
}
