import qbs
import qbs.File
import qbs.Process
import qbs.TextFile

Project {
    name: "QtQml"
    condition: File.exists(project.sourcePath + "/qtdeclarative")

    QtModule {
        name: "QtQml"
        condition: configure.qml

        readonly property path basePath: project.sourcePath
                                         + "/qtdeclarative/src/qml"

        property bool disassembler: false

        includeDependencies: ["QtCore-private", "QtGui", "QtNetwork", "QtQml", "QtQml-private"]

        cpp.defines: [
            "QT_BUILD_QML_LIB",
        ].concat(base)

        cpp.dynamicLibraries: {
            var dynamicLibraries = base;
            if (qbs.targetOS.contains("unix"))
                dynamicLibraries.push("pthread");
            if (qbs.targetOS.contains("windows"))
                dynamicLibraries.push("shell32");
            return dynamicLibraries;
        }

        cpp.includePaths: {
            var includePaths = base;

            if (qbs.targetOS.contains("windowsce"))
                includePaths.push(masmPath + "/stubs/compat");

            return includePaths;
        }

        Depends { name: "double-conversion" }
        Depends { name: "masm" }
        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtNetwork" }
        Depends { name: "QtQmlHeaders" }

        QtQmlHeaders {
            name: "headers"
            fileTags: "moc"
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
            fileTags: "moc"
            overrideTags: false
        }
    }
}
