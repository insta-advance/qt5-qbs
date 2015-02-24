import qbs

QtModule {
    name: "QtQml"
    property path basePath: project.sourceDirectory + "/qtdeclarative/src/qml"

    Depends { name: "QtQmlHeaders" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }
    // Depends { name: "double-conversion" }
    // Depends { name: "masm" }

    QtHost.includes.modules: [ "qml", "qml-private" ]

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "animations/*.cpp",
            "compiler/*.cpp",
            "debugger/*.cpp",
            "jit/*.cpp",
            "jsapi/*.cpp",
            "jsruntime/*.cpp",
            "parser/*.cpp",
            "qml/*.cpp",
            "types/*.cpp",
            "util/*.cpp",
        ]
    }

    QtQmlHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: [
            // Class declaration lacks Q_OBJECT macro
            "qml/qqmlabstracturlinterceptor.h",
        ]
    }
}
