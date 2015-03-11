import qbs

Module {
    property stringList environment: [
        "QT_SELECT=qhost",
    ]

    cpp.includePaths: product.buildDirectory + "/.uic"

    Depends { name: "cpp" }

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
            cmd.environment = product.moduleProperty("QtHost.uic", "environment");
            cmd.description = "uic " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }
}
