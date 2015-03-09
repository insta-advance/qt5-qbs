import qbs
import qbs.FileInfo

Product {
    readonly property path includeDirectory: project.buildDirectory + "/include"
    property stringList includeDependencies: []

    cpp.defines: configure.defines

    cpp.includePaths: {
        var includes = [
            includeDirectory,
            project.sourceDirectory + "/qtbase/mkspecs/" + project.target,
        ];
        for (var i in includeDependencies) {
            var module = includeDependencies[i];
            if (module.endsWith("-private")) {
                module = module.slice(0, -8);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module + "/private");
                if (module == "QtGui") {
                    includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                                   + "/" + module + "/qpa");
                }
            }
            includes.push(includeDirectory + "/" + module);
        }
        return includes;
    }

    Depends { name: "configure" }
    Depends { name: "cpp" }

    Properties {
        condition: qbs.toolchain.contains("gcc") && !qbs.toolchain.contains("clang")
        cpp.cxxFlags: base.concat(["-Wno-psabi"])
    }

    Properties {
        condition: qbs.targetOS.contains("windows") && qbs.toolchain.contains("msvc")
        cpp.defines: base.concat([
            "_SCL_SECURE_NO_WARNINGS",
        ])
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
                cmd.environment = [
                    "QT_SELECT=qhost",
                ];
                cmd.description = "moc " + input.fileName;
                cmd.highlight = "codegen";
                commands.push(cmd);
            }
            return commands;
        }
    }
}
