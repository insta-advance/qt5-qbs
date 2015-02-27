import qbs
import qbs.Process
import qbs.TextFile

QtModule {
    name: "QtQml"
    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/qml"

    property bool disassembler: false

    cpp.defines: base.concat(["QT_BUILD_QML_LIB"])

    cpp.dynamicLibraries: {
        var dynamicLibraries = [];

        if (qbs.targetOS.contains("unix"))
            dynamicLibraries.push("pthread");

        return dynamicLibraries;
    }

    cpp.includePaths: {
        var includePaths = base;

        if (qbs.targetOS.contains("windowsce"))
            includePaths.push(masmPath + "/stubs/compat");

        return includePaths;
    }

    QtHost.includes.modules: ["qml", "qml-private"]

    Depends { name: "double-conversion" }
    Depends { name: "masm" }
    Depends { name: "QtQmlHeaders" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }

    Group {
        id: sources_moc
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
            "qml/qqmlfile.cpp",
            "qml/qqmltypeloader.cpp",
            "qml/qqmlwatcher.cpp",
            "qml/qqmlxmlhttprequest.cpp",
            "types/qquickworkerscript.cpp",
            "util/qqmladaptormodel.cpp",
        ]
        fileTags: "moc_cpp"
        overrideTags: false
    }

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
            "qml/ftw/*.cpp",
            "qml/v8/*.cpp",
            "types/*.cpp",
            "util/*.cpp",
        ]
        excludeFiles: sources_moc.files
    }

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
        prefix: basePath + "/"
        files: [
            "debugger/qqmldebugserver_p.h",
            "jsapi/qjsengine.h",
            "qml/qqmlapplicationengine.h",
            "qml/qqmlapplicationengine_p.h",
            "qml/qqmlexpression.h",
            "types/qqmlinstantiator_p.h",
        ]
        fileTags: "moc_hpp_p"
    }

    QtQmlHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: [
            // Class declaration lacks Q_OBJECT macro
            "qml/qqmlabstracturlinterceptor.h",
        ].concat(headers_moc_p.files)
    }

    Export {
        Depends { name: "QtHost.includes" }
        QtHost.includes.modules: ["qml", "qml-private"]
    }
}
