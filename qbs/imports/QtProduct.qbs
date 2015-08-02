import qbs
import qbs.FileInfo
import "QtUtils.js" as QtUtils

Product {
    Depends { name: "cpp" }
    Depends { name: "rcc"; profiles: project.hostProfile }
    Depends { name: "moc"; profiles: project.hostProfile }

    profiles: project.targetProfiles

    Depends { name: "Android.ndk"; condition: qbs.targetOS.contains("android") }

    cpp.cxxFlags: {
        var cxxFlags = [];
        if (qbs.toolchain.contains("gcc")) {
            if (sse2)
                cxxFlags.push("-msse2");
            if (sse3)
                cxxFlags.push("-msse3");
            if (ssse3)
                cxxFlags.push("-mssse3");
            if (sse4_1)
                cxxFlags.push("-msse4.1");
            if (sse4_2)
                cxxFlags.push("-msse4.2");
            if (avx)
                cxxFlags.push("-mavx");
            if (avx2)
                cxxFlags.push("-mavx2");
            if (neon)
                cxxFlags.push("-mfpu=neon");
            if (cxx11)
                cxxFlags.push("-std=c++11");
        }
        return cxxFlags;
    }

    cpp.defines: {
        var defines = [
            "QT_BUILDING_QT",
            "QT_MOC_COMPAT",
            "_USE_MATH_DEFINES",
            "QT_ASCII_CAST_WARNINGS",
            "QT_DEPRECATED_WARNINGS",
            "QT_DISABLE_DEPRECATED_BEFORE=0x040800",
            "QT_USE_QSTRINGBUILDER",
        ];

        if (qbs.targetOS.contains("windows")) {
            defines.push("_WIN32");
            if (qbs.toolchain.contains("msvc"))
                defines.push("_SCL_SECURE_NO_WARNINGS");
        }

        return defines;
    }

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/mkspecs/" + project.targetMkspec,
        product.buildDirectory + "/.moc",
        product.buildDirectory + "/.uic",
        project.buildDirectory + "/include",
    ]

    Properties {
        condition: qbs.toolchain.contains("gcc") && project.rpath
        cpp.rpaths: qbs.installRoot + "/lib"
    }

    Rule {
        name: "QtCoreMocRule"
        inputs: "moc"
        explicitlyDependsOn: "qconfig"
        outputFileTags: ["cpp", "hpp"]
        outputArtifacts: {
            var mocinfo = QtMocScanner.apply(input);
            if (!mocinfo.hasQObjectMacro)
                return [];

            var artifacts = [];
            if (input.fileTags.contains("hpp") && !mocinfo.mustCompile) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/moc_" + input.completeBaseName + ".cpp",
                    fileTags: "hpp"
                });
            }

            if (input.fileTags.contains("hpp") && mocinfo.mustCompile) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/" + input.completeBaseName + "_moc.cpp",
                    fileTags: "cpp"
                });
            }

            if (input.fileTags.contains("cpp")) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/" + input.completeBaseName + ".moc",
                    fileTags: "hpp"
                });
            }

            return artifacts;
        }
        prepare: {
            var arguments = [
                //"--no-warnings",
            ];

            var defines = product.moduleProperty("cpp", "defines");
            for (var i in defines) {
                arguments.push("-D");
                arguments.push(defines[i]);
            }

            var includes = product.moduleProperty("cpp", "includePaths");
            for (var i in includes) {
                arguments.push("-I");
                arguments.push(includes[i]);
            }

            var allOutputs = [];
            if (outputs.cpp)
                allOutputs = allOutputs.concat(outputs.cpp);
            if (outputs.hpp)
                allOutputs = allOutputs.concat(outputs.hpp);
            if (!allOutputs.length)
                throw "QtLibrary.moc: outputs is empty.";

            var commands = [];
            for (var i in allOutputs) {
                var cmd = new Command(project.buildDirectory + "/bin/moc", arguments.concat([
                    input.fileName, "-o", allOutputs[i].filePath,
                ]));
                cmd.workingDirectory = FileInfo.path(input.filePath);
                cmd.description = "moc " + input.fileName;
                cmd.highlight = "codegen";
                commands.push(cmd);
            }
            return commands;
        }
    }

    Rule {
        inputs: "rcc"
        Artifact {
            fileTags: "cpp"
            filePath: product.buildDirectory + "/.rcc/" + input.baseName + "_rcc.cpp"
        }
        prepare: {
            var cmd = new Command(project.buildDirectory  + "/bin/rcc", [
                input.filePath,
                "--name", input.baseName,
                "-o", output.filePath,
            ]);
            cmd.description = "rcc " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }

    Rule {
        inputs: "uic"
        Artifact {
            fileTags: "hpp"
            filePath: product.buildDirectory + "/.uic/ui_" + input.baseName + ".h"
        }
        prepare: {
            var cmd = new Command(project.buildDirectory  + "/bin/uic", [
                "-o", output.filePath,
                input.filePath,
            ]);
            cmd.description = "uic " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }

    FileTagger {
        patterns: ["*.h", "*.cpp"]
        fileTags: "moc"
    }

    FileTagger {
        patterns: "*.qrc"
        fileTags: "rcc"
    }

    FileTagger {
        patterns: "*.ui"
        fileTags: "uic"
    }
}
