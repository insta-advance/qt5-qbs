import qbs
import qbs.Process
import qbs.TextFile

QtModule {
    name: "QtQml"
    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/qml"
    readonly property path masmPath: project.sourceDirectory
                                     + "/qtdeclarative/src/3rdparty/masm"

    property bool disassembler: false

    cpp.defines: {
        var defines = [
            "QT_BUILD_QML_LIB",
            "WTF_EXPORT_PRIVATE=",
            "JS_EXPORT_PRIVATE=",
            "WTFReportAssertionFailure=qmlWTFReportAssertionFailure",
            "WTFReportBacktrace=qmlWTFReportBacktrace",
            "WTFInvokeCrashHook=qmlWTFInvokeCrashHook",
            "NOMINMAX",
            "ENABLE_LLINT=0",
            "ENABLE_DFG_JIT=0",
            "ENABLE_DFG_JIT_UTILITY_METHODS=1",
            "ENABLE_JIT_CONSTANT_BLINDING=0",
            "BUILDING_QT__",
        ];

        if (qbs.enableDebugCode)
            defines.push("NDEBUG");

        if (product.disassembler) {
            if (qbs.architecture.startsWith("x86"))
                defines.push("WTF_USE_UDIS86=1");
            if (qbs.architecture == "arm")
                defines.push("WTF_USE_ARMV7_DISASSEMBLER=1");
        } else {
            defines.push("WTF_USE_UDIS86=0");
        }

        return defines;
    }

    cpp.dynamicLibraries: {
        var dynamicLibraries = [];

        if (qbs.targetOS.contains("unix"))
            dynamicLibraries.push("pthread");

        return dynamicLibraries;
    }

    cpp.includePaths: {
        var includePaths = [
            product.buildDirectory,
            masmPath,
            masmPath + "/assembler",
            masmPath + "/disassembler",
            masmPath + "/disassembler/udis86",
            masmPath + "/jit",
            masmPath + "/runtime",
            masmPath + "/stubs",
            masmPath + "/stubs/wtf",
            masmPath + "/wtf",
        ];

        if (qbs.targetOS.contains("windowsce"))
            includePaths.push(masmPath + "/stubs/compat");

        return includePaths;
    }

    QtHost.includes.modules: ["qml", "qml-private"]

    Depends { name: "double-conversion" }
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

    Group {
        name: "sources (masm)"
        prefix: masmPath + "/"
        files: [
            "assembler/ARMv7Assembler.cpp",
            "assembler/LinkBuffer.cpp",
            "disassembler/Disassembler.cpp",
            "wtf/*.cpp",
            "stubs/*.cpp",
            "yarr/*.cpp",
        ]
    }

    Group {
        condition: product.disassembler
        name: "sources (masm disassembler)"
        prefix: masmPath + "/disassembler/"
        files: [
            "ARMv7/*.cpp",
            "udis86/*.c",
            "UDis86Disassembler.cpp",
            "udis86/optable.xml",
        ]
    }

    Transformer {
        condition: product.disassembler
        inputs: product.masmPath + "/disassembler/udis86/optable.xml"
        Artifact {
            filePath: "udis86_itab.c"
            fileTags: "hpp"
        }
        Artifact {
            filePath: "udis86_itab.h"
            fileTags: "hpp"
        }
        prepare: {
            var cmd = new Command("python", [
                product.masmPath + "/disassembler/udis86/itab.py",
                input.filePath
            ]);
            cmd.description = "generating itab";
            cmd.workingDirectory = product.buildDirectory;
            return cmd;
        }
    }

    Export {
        Depends { name: "QtHost.includes" }
        QtHost.includes.modules: ["qml", "qml-private"]
    }
}
