import qbs

QtModule {
    name: "QtWidgets"
    condition: configure.widgets

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/widgets"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtWidgets-private"]

    cpp.defines: {
        var defines = base.concat([
            "QT_BUILD_WIDGETS_LIB",
        ]);
        if (!configure.androidstyle)
            defines.push("QT_NO_STYLE_ANDROID");
        if (!configure.gtkstyle)
            defines.push("QT_NO_STYLE_GTK");
        if (!configure.windowsvistastyle)
            defines.push("QT_NO_STYLE_WINDOWSVISTA");
        return defines;
    }

    Depends { name: "opengl-desktop"; condition: configure.opengl == "desktop" }
    Depends { name: "opengl-es2"; condition: configure.opengl == "es2" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtWidgetHeaders" }

    QtWidgetHeaders {
        name: "headers"
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "accessible/*.cpp",
            "dialogs/*.cpp",
            "effects/*.cpp",
            "graphicsview/*.cpp",
            "itemviews/*.cpp",
            "kernel/*.cpp",
            "statemachine/*.cpp",
            "styles/*.cpp",
            "util/*.cpp",
            "widgets/*.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }
}
