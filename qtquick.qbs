import qbs

Project {
    name: "QtQuick"

    Project {
        name: "imports"
        references: [
            "quick/qtquick2.qbs",
            "quick/qtquick2window.qbs",
        ]
    }

    QtModule {
        name: "QtQuick"
        condition: configure.quick

        readonly property path basePath: configure.sourcePath
                                         + "/qtdeclarative/src/quick"

        includeDependencies: [
            "QtCore-private",
            "QtGui-private",
            "QtQml-private",
            "QtNetwork",
            "QtQuick-private",
        ]

        cpp.defines: {
            var defines = [
                "QT_BUILD_QUICK_LIB",
            ];
            if (!configure.cursor)
                defines.push("QT_NO_CURSOR");
            return defines.concat(base);
        }

        cpp.dynamicLibraries: {
            var dynamicLibraries = base;
            if (qbs.targetOS.contains("windows"))
                dynamicLibraries.push("user32");
            return dynamicLibraries;
        }

        Depends { name: "opengl" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtNetwork" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuickHeaders" }

        QtQuickHeaders {
            name: "headers"
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
}
