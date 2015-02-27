import qbs

Module {
    property stringList environment: [
        "QT_SELECT=qhost",
    ]
    property stringList arguments: [
        "--no-warnings",
    ]
    property stringList includePaths: [
        project.buildDirectory + "/include",
    ]

    Depends { name: "cpp" }

    cpp.includePaths: [
        product.buildDirectory + "/.moc",
    ]

    Rule {
        inputs: ["moc_hpp_p", "moc_hpp", "moc_cpp"]
        explicitlyDependsOn: "qconfig"
        outputFileTags: ["cpp", "hpp"]
        outputArtifacts: {
            var artifacts = [];
            if (input.fileTags.contains("moc_hpp_p")) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/moc_" + input.baseName + ".cpp",
                    fileTags: "hpp"
                });
            }
            if (input.fileTags.contains("moc_hpp")) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/" + input.baseName + "_moc.cpp",
                    fileTags: "cpp"
                });
            }
            if (input.fileTags.contains("moc_cpp")) {
                artifacts.push({
                    filePath: product.buildDirectory + "/.moc/" + input.baseName + ".moc",
                    fileTags: "hpp"
                });
            }
            return artifacts;
        }
        prepare: {
            var arguments = product.moduleProperty("QtHost.moc", "arguments");

            var defines = product.moduleProperty("cpp", "defines");
            for (var i in defines) {
                arguments.push("-D");
                arguments.push(defines[i]);
            }

            var includes = product.moduleProperty("QtHost.moc", "includePaths");
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
                throw "QtHost.moc: outputs is empty.";

            var commands = [];
            for (var i in allOutputs) {
                var args = arguments.concat([
                    input.filePath,
                    "-o", allOutputs[i].filePath
                ]);
                var cmd = new Command("moc", args);
                cmd.environment = product.moduleProperty("QtHost.moc", "environment");
                cmd.description = "moc'ing " + input.fileName;
                commands.push(cmd);
            }
            return commands;
        }
    }
}
