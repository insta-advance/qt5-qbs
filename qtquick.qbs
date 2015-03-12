import qbs

QtModule {
    name: "QtQuick"
    condition: configure.quick

    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/quick"

    includeDependencies: [
        "QtCore-private",
        "QtGui-private",
        "QtQml-private",
        "QtNetwork",
        "QtQuick-private",
    ]

    cpp.defines: {
        var defines = base.concat([
            "QT_BUILD_QUICK_LIB",
        ]);
        if (!configure.cursor)
            defines.push("QT_NO_CURSOR");
        return defines;
    }

    Depends { name: "opengl-desktop"; condition: configure.opengl == "desktop" }
    Depends { name: "opengl-es2"; condition: configure.opengl == "es2" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuickHeaders" }

    QtQuickHeaders {
        name: "headers"
        /*excludeFiles: {
            var excludeFiles = [];
            if (!configure.cursor) {
                excludeFiles.push("items/qquickdroparea_p.h");
                excludeFiles.push("items/qquickdrag_p.h");
            }
            return excludeFiles;
        }*/
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp",
            "accessible/*.cpp",
            "designer/*.cpp",
            "items/*.cpp",
            "items/context2d/*.cpp",
            "scenegraph/*.cpp",
            "scenegraph/coreapi/*.cpp",
            "scenegraph/util/*.cpp",
            "util/*.cpp",
        ]
        /*excludeFiles: {
            var excludeFiles = [];
            if (!configure.cursor) {
                excludeFiles.push("items/qquickdroparea.cpp");
                excludeFiles.push("items/qquickdragcpp");
            }
            return excludeFiles;
        }*/
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "resources"
        prefix: basePath + "/"
        files: [
            "items/items.qrc",
            "scenegraph/scenegraph.qrc",
        ]
        fileTags: "qrc"
    }
}
