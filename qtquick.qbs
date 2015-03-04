import qbs

QtModule {
    name: "QtQuick"
    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/quick"

    includeDependencies: [
        "QtCore", "QtCore-private",
        "QtGui", "QtGui-private",
        "QtQml", "QtQml-private",
        "QtNetwork",
        "QtQuick", "QtQuick-private"
    ]

    cpp.defines: base.concat([
        "QT_BUILD_QUICK_LIB",
    ])

    cpp.dynamicLibraries: [
        "GLESv2",
    ]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuickHeaders" }

    QtQuickHeaders {
        name: "headers"
        excludeFiles: {
            var excludeFiles = [
                "scenegraph/coreapi/qsgmaterial.h", // "Meta object features not supported for nested classes"
            ];

            if (!QtHost.config.cursor) {
                excludeFiles.push("items/qquickdroparea_p.h");
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