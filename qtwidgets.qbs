import qbs

Project {
    name: "QtWidgets"
    QtModule {
        name: "QtWidgets"
        condition: configure.widgets

        readonly property path basePath: project.sourcePath + "/qtbase/src/widgets"

        includeDependencies: ["QtCore-private", "QtGui-private", "QtWidgets-private"]

        cpp.defines: {
            var defines = [
                "QT_BUILD_WIDGETS_LIB",
            ];
            if (!configure.androidstyle)
                defines.push("QT_NO_STYLE_ANDROID");
            if (!configure.gtkstyle)
                defines.push("QT_NO_STYLE_GTK");
            if (!configure.macstyle)
                defines.push("QT_NO_STYLE_MAC");
            if (!configure.windowscestyle)
                defines.push("QT_NO_STYLE_WINDOWSCE");
            if (!configure.windowsmobilestyle)
                defines.push("QT_NO_STYLE_WINDOWSMOBILE");
            if (!configure.windowsvistastyle)
                defines.push("QT_NO_STYLE_WINDOWSVISTA");
            if (!configure.windowsxpstyle)
                defines.push("QT_NO_STYLE_WINDOWSXP");
            if (!configure.cursor)
                defines.push("QT_NO_CURSOR");
            return defines.concat(base);
        }

        cpp.dynamicLibraries: {
            var dynamicLibraries = base;
            if (qbs.targetOS.contains("windows")) {
                dynamicLibraries.push("gdi32");
                dynamicLibraries.push("shell32");
                dynamicLibraries.push("user32");
            }
            return dynamicLibraries;
        }

        Depends { name: "opengl" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtWidgetHeaders" }

        QtWidgetHeaders {
            name: "headers"
            excludeFiles: {
                var excludeFiles = [];
                if (!qbs.targetOS.contains("osx")) {
                    excludeFiles.push("widgets/qmaccocoaviewcontainer_mac.h");
                    excludeFiles.push("widgets/qmacnativewidget_mac.h");
                }
                return excludeFiles;
            }
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
            excludeFiles: {
                var excludeFiles = [];
                if (!qbs.targetOS.contains("wince")) {
                    excludeFiles.push("kernel/qwidgetsfunctions_wince.cpp");
                    excludeFiles.push("util/qsystemtrayicon_wince.cpp");
                }
                if (!qbs.targetOS.contains("windows")) {
                    excludeFiles.push("util/qsystemtrayicon_win.cpp");
                }
                if (!configure.xcb) {
                    excludeFiles.push("util/qsystemtrayicon_x11.cpp");
                }
                if (configure.xcb || !qbs.targetOS.contains("unix")) {
                    excludeFiles.push("util/qsystemtrayicon_qpa.cpp");
                }
                if (!configure.windowsxpstyle) {
                    excludeFiles.push("styles/qwindowsxpstyle.cpp");
                }
                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "forms"
            prefix: basePath + "/"
            files: "dialogs/*.ui"
            fileTags: "uic"
            overrideTags: false
        }

        Group {
            name: "resources"
            prefix: basePath + "/"
            files: {
                var files = ["dialogs/qmessagebox.qrc"]
                if (qbs.targetOS.contains("windowsce"))
                    files.push("styles/qstyle_wince.qrc");
                else
                    files.push("styles/qstyle.qrc");
                return files;
            }
            fileTags: "qrc"
            overrideTags: false
        }
    }
}
