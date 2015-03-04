import qbs
import qbs.File
import qbs.Process
import qbs.TextFile

QtProduct {
    type: "staticlibrary"
    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/3rdparty/masm"

    cpp.defines: {
        var defines = [
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

    property stringList includePaths: [
        basePath,
        basePath + "/assembler",
        basePath + "/disassembler",
        basePath + "/disassembler/udis86",
        basePath + "/jit",
        basePath + "/runtime",
        basePath + "/stubs",
        basePath + "/stubs/wtf",
        basePath + "/wtf",
    ];

    includeDependencies: ["QtCore", "QtQml-private"]

    cpp.includePaths: base.concat(product.includePaths.concat([product.buildDirectory]))

    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtQmlHeaders" }
    Depends { name: "cpp" }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "assembler/ARMv7Assembler.cpp",
            "assembler/LinkBuffer.cpp",
            "disassembler/Disassembler.cpp",
            "wtf/*.cpp",
            "stubs/*.cpp",
            "yarr/*.cpp",
        ]
    }

    Transformer {
        Artifact {
            filePath: product.buildDirectory + "/RegExpJitTables.h"
            fileTags: "hpp"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.masmPath = product.basePath;
            cmd.sourceCode = function() {
                // The header is static; don't regenerate it if it exists
                if (File.exists(output.filePath))
                    return;

                var process = new Process();
                process.setWorkingDirectory(masmPath);
                var exitCode = process.exec("python", ["create_regex_tables"], true);
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write(process.readStdOut());
                process.close();
                file.close();
            };
            return cmd;
        }
    }

    Group {
        condition: product.disassembler
        name: "sources (disassembler)"
        prefix: basePath + "/disassembler/"
        files: [
            "ARMv7/*.cpp",
            "udis86/*.c",
            "UDis86Disassembler.cpp",
            "udis86/optable.xml",
        ]
    }

    Transformer {
        condition: product.disassembler
        inputs: product.basePath + "/disassembler/udis86/optable.xml"
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
                product.basePath + "/disassembler/udis86/itab.py",
                input.filePath
            ]);
            cmd.description = "generating itab";
            cmd.highlight = "codegen";
            cmd.workingDirectory = product.buildDirectory;
            return cmd;
        }
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: product.includePaths
        cpp.defines: product.cpp.defines
    }
}