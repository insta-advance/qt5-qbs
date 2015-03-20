import qbs

Module {
    property stringList environment: [
        "QT_SELECT=qhost",
    ]

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
            cmd.environment = product.moduleProperty("QtHost.rcc", "environment");
            cmd.description = "rcc " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }
}
