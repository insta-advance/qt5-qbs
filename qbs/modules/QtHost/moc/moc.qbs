import qbs

Module {
    property stringList environment: [
        "QT_SELECT=qhost",
    ]
    property stringList arguments: [
        "--no-warnings",
        "-I", project.buildDirectory + "/include",
    ]

    Depends { name: "cpp" }
    cpp.includePaths: [
        product.buildDirectory + "/.moc",
    ]

    Rule {
        inputs: ["moc_hpp_p", "moc_hpp", "moc_cpp"]
        auxiliaryInputs: "synced_hpp"
        outputArtifacts: {
            var artifact = { };
            if (input.fileTags.contains("moc_hpp_p")) {
                artifact.filePath = product.buildDirectory + "/.moc/moc_" + input.baseName + ".cpp";
                artifact.fileTags = "hpp";
            } else if (input.fileTags.contains("moc_hpp")) {
                artifact.filePath = product.buildDirectory + "/.moc/" + input.baseName + "_moc.cpp";
                artifact.fileTags = "cpp";
            } else if (input.fileTags.contains("moc_cpp")) {
                artifact.filePath = product.buildDirectory + "/.moc/" + input.baseName + ".moc";
                artifact.fileTags = "hpp";
            }
            return [artifact];
        }
        outputFileTags: ["cpp", "hpp"]
        prepare: {
            var cmd = new Command("moc", product.moduleProperty("QtHost.moc", "arguments"));

            var defines = product.moduleProperty("cpp", "defines");
            for (var i in defines) {
                cmd.arguments.push("-D");
                cmd.arguments.push(defines[i]);
            }

            var includes = product.moduleProperty("cpp", "includePaths");
            for (var i in includes) {
                cmd.arguments.push("-I");
                cmd.arguments.push(includes[i]);
            }

            cmd.arguments.push(input.filePath);
            cmd.arguments.push("-o");
            cmd.arguments.push(output.filePath);
            cmd.environment = product.moduleProperty("QtHost.moc", "environment");
            cmd.silent = true;
            return cmd;
        }
    }
}
