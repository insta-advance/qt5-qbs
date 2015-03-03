import qbs

// Base type for QtModule and QtPlugin
QtProduct {
    type: "dynamiclibrary" // ### food for thought: delay linking for another step, making headers the only dependency
    property bool moc: true

    cpp.defines: [
        "QT_BUILDING_QT",
        "_USE_MATH_DEFINES",
        "QT_ASCII_CAST_WARNINGS",
        "QT_MOC_COMPAT",
        "QT_DEPRECATED_WARNINGS",
        "QT_DISABLE_DEPRECATED_BEFORE=0x040800",
    ]

    cpp.includePaths: base.concat([
        product.buildDirectory + "/.moc",
    ])

    Properties {
        condition: qbs.targetOS.contains("windows") && qbs.toolchain.contains("msvc")
        cpp.defines: [
            "_SCL_SECURE_NO_WARNINGS",
        ]
    }

    Depends { name: "cpp" }
    Depends { name: "QtHost"; submodules: ["config", "rcc"] }

    Rule {
        condition: product.moc
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
                    input.filePath, "-o", allOutputs[i].filePath,
                ]));
                cmd.environment = [
                    "QT_SELECT=qhost",
                ];
                cmd.description = "moc'ing " + input.fileName;
                commands.push(cmd);
            }
            return commands;
        }
    }
}
