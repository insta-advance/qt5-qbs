import qbs
import qbs.File
import qbs.Process
import qbs.TextFile
import "create_regex_tables.js" as CreateRegExpTables

QtModule {
    name: "QtQml"

    readonly property path basePath: project.sourceDirectory + "/qtdeclarative/src/qml/"
    readonly property path masmPath: project.sourceDirectory + "/qtdeclarative/src/3rdparty/masm/"

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

        return defines.concat(base);
    }

    cpp.dynamicLibraries: {
        var dynamicLibraries = base;
        if (qbs.targetOS.contains("unix"))
            dynamicLibraries.push("pthread");
        if (qbs.targetOS.contains("windows"))
            dynamicLibraries.push("shell32");
        return dynamicLibraries;
    }

    cpp.includePaths: {
        var includePaths = [
            product.buildDirectory,
            masmPath,
            masmPath + "assembler",
            masmPath + "disassembler",
            masmPath + "jit",
            masmPath + "runtime",
            masmPath + "stubs",
            masmPath + "stubs/wtf",
            masmPath + "wtf",
        ];
        if (qbs.targetOS.contains("windowsce"))
            includePaths.push(masmPath + "/stubs/compat");
        return includePaths.concat(base);
    }

    Depends { name: "double-conversion" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtNetworkHeaders" }
    Depends { name: "QtQmlHeaders" }

    QtQmlHeaders {
        name: "headers"
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "animations/qabstractanimationjob.cpp",
            "animations/qanimationgroupjob.cpp",
            "animations/qcontinuinganimationgroupjob.cpp",
            "animations/qparallelanimationgroupjob.cpp",
            "animations/qpauseanimationjob.cpp",
            "animations/qsequentialanimationgroupjob.cpp",
            "compiler/qqmlirbuilder.cpp",
            "compiler/qqmltypecompiler.cpp",
            "compiler/qv4codegen.cpp",
            "compiler/qv4compileddata.cpp",
            "compiler/qv4compiler.cpp",
            "compiler/qv4instr_moth.cpp",
            "compiler/qv4isel_moth.cpp",
            "compiler/qv4isel_p.cpp",
            "compiler/qv4jsir.cpp",
            "compiler/qv4ssa.cpp",
            "debugger/qdebugmessageservice.cpp",
            "debugger/qqmlabstractprofileradapter.cpp",
            "debugger/qqmlconfigurabledebugservice.cpp",
            "debugger/qqmldebugserver.cpp",
            "debugger/qqmldebugservice.cpp",
            "debugger/qqmlenginecontrolservice.cpp",
            "debugger/qqmlenginedebugservice.cpp",
            "debugger/qqmlinspectorservice.cpp",
            "debugger/qqmlprofiler.cpp",
            "debugger/qqmlprofilerservice.cpp",
            "debugger/qv4debugservice.cpp",
            "debugger/qv4profileradapter.cpp",
            "jit/qv4assembler.cpp",
            "jit/qv4binop.cpp",
            "jit/qv4isel_masm.cpp",
            "jit/qv4regalloc.cpp",
            "jit/qv4unop.cpp",
            "jsapi/qjsengine.cpp",
            "jsapi/qjsvalue.cpp",
            "jsapi/qjsvalueiterator.cpp",
            "jsruntime/qv4argumentsobject.cpp",
            "jsruntime/qv4arraybuffer.cpp",
            "jsruntime/qv4arraydata.cpp",
            "jsruntime/qv4arrayobject.cpp",
            "jsruntime/qv4booleanobject.cpp",
            "jsruntime/qv4context.cpp",
            "jsruntime/qv4dataview.cpp",
            "jsruntime/qv4dateobject.cpp",
            "jsruntime/qv4debugging.cpp",
            "jsruntime/qv4engine.cpp",
            "jsruntime/qv4errorobject.cpp",
            "jsruntime/qv4executableallocator.cpp",
            "jsruntime/qv4function.cpp",
            "jsruntime/qv4functionobject.cpp",
            "jsruntime/qv4globalobject.cpp",
            "jsruntime/qv4identifier.cpp",
            "jsruntime/qv4identifiertable.cpp",
            "jsruntime/qv4include.cpp",
            "jsruntime/qv4internalclass.cpp",
            "jsruntime/qv4jsonobject.cpp",
            "jsruntime/qv4lookup.cpp",
            "jsruntime/qv4managed.cpp",
            "jsruntime/qv4mathobject.cpp",
            "jsruntime/qv4memberdata.cpp",
            "jsruntime/qv4numberobject.cpp",
            "jsruntime/qv4object.cpp",
            "jsruntime/qv4objectiterator.cpp",
            "jsruntime/qv4objectproto.cpp",
            "jsruntime/qv4persistent.cpp",
            "jsruntime/qv4profiling.cpp",
            "jsruntime/qv4qobjectwrapper.cpp",
            "jsruntime/qv4regexp.cpp",
            "jsruntime/qv4regexpobject.cpp",
            "jsruntime/qv4runtime.cpp",
            "jsruntime/qv4script.cpp",
            "jsruntime/qv4sequenceobject.cpp",
            "jsruntime/qv4serialize.cpp",
            "jsruntime/qv4sparsearray.cpp",
            "jsruntime/qv4string.cpp",
            "jsruntime/qv4stringobject.cpp",
            "jsruntime/qv4typedarray.cpp",
            "jsruntime/qv4value.cpp",
            "jsruntime/qv4variantobject.cpp",
            "jsruntime/qv4vme_moth.cpp",
            "memory/qv4mm.cpp",
            "parser/qqmljsast.cpp",
            "parser/qqmljsastvisitor.cpp",
            "parser/qqmljsengine_p.cpp",
            "parser/qqmljsgrammar.cpp",
            "parser/qqmljslexer.cpp",
            "parser/qqmljsparser.cpp",
            "qml/qqmlabstractbinding.cpp",
            "qml/qqmlabstracturlinterceptor.cpp",
            "qml/qqmlaccessors.cpp",
            "qml/qqmlapplicationengine.cpp",
            "qml/qqmlbinding.cpp",
            "qml/qqmlboundsignal.cpp",
            "qml/qqmlcleanup.cpp",
            "qml/qqmlcompileddata.cpp",
            "qml/qqmlcomponent.cpp",
            "qml/qqmlcontext.cpp",
            "qml/qqmlcontextwrapper.cpp",
            "qml/qqmlcustomparser.cpp",
            "qml/qqmldirparser.cpp",
            "qml/qqmlengine.cpp",
            "qml/qqmlerror.cpp",
            "qml/qqmlexpression.cpp",
            "qml/qqmlextensionplugin.cpp",
            "qml/qqmlfile.cpp",
            "qml/qqmlfileselector.cpp",
            "qml/qqmlglobal.cpp",
            "qml/qqmlimport.cpp",
            "qml/qqmlincubator.cpp",
            "qml/qqmlinfo.cpp",
            "qml/qqmljavascriptexpression.cpp",
            "qml/qqmllist.cpp",
            "qml/qqmllistwrapper.cpp",
            "qml/qqmllocale.cpp",
            "qml/qqmlmemoryprofiler.cpp",
            "qml/qqmlmetatype.cpp",
            "qml/qqmlnetworkaccessmanagerfactory.cpp",
            "qml/qqmlnotifier.cpp",
            "qml/qqmlobjectcreator.cpp",
            "qml/qqmlopenmetaobject.cpp",
            "qml/qqmlparserstatus.cpp",
            "qml/qqmlplatform.cpp",
            "qml/qqmlproperty.cpp",
            "qml/qqmlpropertycache.cpp",
            "qml/qqmlpropertyvalueinterceptor.cpp",
            "qml/qqmlpropertyvaluesource.cpp",
            "qml/qqmlproxymetaobject.cpp",
            "qml/qqmlscriptstring.cpp",
            "qml/qqmlstringconverters.cpp",
            "qml/qqmltypeloader.cpp",
            "qml/qqmltypenamecache.cpp",
            "qml/qqmltypenotavailable.cpp",
            "qml/qqmltypewrapper.cpp",
            "qml/qqmlvaluetype.cpp",
            "qml/qqmlvaluetypeproxybinding.cpp",
            "qml/qqmlvaluetypewrapper.cpp",
            "qml/qqmlvme.cpp",
            "qml/qqmlvmemetaobject.cpp",
            "qml/qqmlwatcher.cpp",
            "qml/qqmlxmlhttprequest.cpp",
            "qml/ftw/qhashedstring.cpp",
            "qml/ftw/qintrusivelist.cpp",
            "qml/ftw/qqmlpool.cpp",
            "qml/ftw/qqmlthread.cpp",
            "qml/v8/qqmlbuiltinfunctions.cpp",
            "qml/v8/qv4domerrors.cpp",
            "qml/v8/qv4sqlerrors.cpp",
            "qml/v8/qv8engine.cpp",
            "types/qqmlbind.cpp",
            "types/qqmlconnections.cpp",
            "types/qqmldelegatemodel.cpp",
            "types/qqmlinstantiator.cpp",
            "types/qqmllistmodel.cpp",
            "types/qqmllistmodelworkeragent.cpp",
            "types/qqmlmodelindexvaluetype.cpp",
            "types/qqmlmodelsmodule.cpp",
            "types/qqmlobjectmodel.cpp",
            "types/qqmltimer.cpp",
            "types/qquickpackage.cpp",
            "types/qquickworkerscript.cpp",
            "util/qqmladaptormodel.cpp",
            "util/qqmlchangeset.cpp",
            "util/qqmllistaccessor.cpp",
            "util/qqmllistcompositor.cpp",
            "util/qqmlpropertymap.cpp",
        ]
    }

    // ### fix file globs
    Group {
        name: "sources_masm"
        prefix: masmPath
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
            cmd.masmPath = product.masmPath;
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write(CreateRegExpTables.arrays);
                file.write(CreateRegExpTables.functions);
                file.close();
            };
            return cmd;
        }
    }

    /*Group {
        name: "sources_regexpjittables"
        prefix: masmPath
        files: "create_regex_tables"
        fileTags: "create_regex_tables"
    }

    Rule {
        inputs: "create_regex_tables"
        Artifact {
            filePath: product.buildDirectory + "/RegExpJitTables.h"
            fileTags: "hpp"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.masmPath = product.masmPath;
            cmd.sourceCode = function() {
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
    }*/

    Group {
        condition: product.disassembler
        name: "sources_disassembler"
        prefix: masmPath + "disassembler/"
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
}
