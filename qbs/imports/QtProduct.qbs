import qbs
import qbs.FileInfo
import "QtUtils.js" as QtUtils

Product {
    readonly property path includeDirectory: project.buildDirectory + "/include"
    property stringList includeDependencies: []
    property stringList hostToolsEnvironment: [
        "QT_SELECT=qhost",
    ]

    condition: configure[name] !== false

    cpp.includePaths: {
        var includes = [
            includeDirectory,
            project.sourcePath + "/qtbase/mkspecs/" + configure.mkspec,
            product.buildDirectory + "/.moc",
            product.buildDirectory + "/.uic",
        ].concat(base);
        for (var i in includeDependencies) {
            var module = includeDependencies[i];
            Array.prototype.push.apply(includes, QtUtils.includesForModule(module, includeDirectory, project.version));
        }
        return includes;
    }

    cpp.defines: {
        var defines = [
            "QT_BUILDING_QT",
            "QT_MOC_COMPAT",
            "_USE_MATH_DEFINES",
        ];

        if (qbs.targetOS.contains("windows")) {
            defines.push("_WIN32");
            if (qbs.toolchain.contains("msvc"))
                defines.push("_SCL_SECURE_NO_WARNINGS");
        }

        if (configure.qreal !== undefined) {
            defines.push("QT_COORD_TYPE=" + properties.qreal);
            defines.push('QT_COORD_TYPE_STRING="' + properties.qreal + '"');
        }

        return defines.concat(configure.baseDefines);
    }

    Depends { name: "configure" }
    Depends { name: "cpp" }

    Properties {
        condition: qbs.toolchain.contains("gcc") && !qbs.toolchain.contains("clang")
        cpp.cxxFlags: [
            "-Wno-psabi"
        ].concat(base)
    }

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cxxFlags: {
            var cxxFlags = base;
            if (configure.cxx11)
                cxxFlags.push("-std=c++11");
            return cxxFlags;
        }
        cpp.rpaths: configure.prefix + "/lib"
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
                "--no-warnings",
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
                var cmd = new Command("moc", arguments.concat([
                    input.fileName, "-o", allOutputs[i].filePath,
                ]));
                cmd.workingDirectory = FileInfo.path(input.filePath);
                cmd.environment = product.hostToolsEnvironment;
                cmd.description = "moc " + input.fileName;
                cmd.highlight = "codegen";
                commands.push(cmd);
            }
            return commands;
        }
    }

    Rule {
        inputs: "qrc"
        Artifact {
            fileTags: "cpp"
            filePath: product.buildDirectory + "/.rcc/" + input.baseName + "_rcc.cpp"
        }
        prepare: {
            var cmd = new Command("rcc", [
                input.filePath,
                "--name", input.baseName,
                "-o", output.filePath,
            ]);
            cmd.environment = product.hostToolsEnvironment;
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
            var cmd = new Command("uic", [
                "-o", output.filePath,
                input.filePath,
            ]);
            cmd.environment = product.hostToolsEnvironment;
            cmd.description = "uic " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }
}
