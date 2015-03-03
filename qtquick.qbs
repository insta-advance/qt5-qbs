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

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
        prefix: basePath + "/"
        files: [
            "items/qquickitem.h",
            "items/qquickwindow.h",
            "items/qquickanchors_p.h",
            "items/qquickloader_p.h",
            "items/qquickstateoperations_p.h",
            "items/qquicktextcontrol_p.h",
            "util/qquickstatechangescript_p.h",
        ]
        fileTags: "moc_hpp_p"
        overrideTags: true
    }

    QtQuickHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: {
            var excludeFiles = [
                "scenegraph/coreapi/qsgmaterial.h", // "Meta object features not supported for nested classes"
            ].concat(headers_moc_p.files);

            if (!QtHost.config.cursor) {
                excludeFiles.push("items/qquickdroparea_p.h");
            }

            return excludeFiles;
        }
    }

    Group {
        id: sources_moc
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
            "items/qquickimage.cpp",
            "items/qquickflipable.cpp",
            "items/qquickframebufferobject.cpp",
            "items/qquickwindow.cpp",
            "items/qquickshadereffectsource.cpp",
            "scenegraph/qsgcontext.cpp",
            "scenegraph/qsgrenderloop.cpp",
            "scenegraph/qsgthreadedrenderloop.cpp",
            "util/qquickfontloader.cpp",
            "util/qquickpixmapcache.cpp",
            "util/qquickprofiler.cpp",
        ]
        fileTags: "moc_cpp"
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
        excludeFiles: sources_moc.files
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
