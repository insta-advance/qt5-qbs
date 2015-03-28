import qbs

QtProduct {
    type: "application"

    destinationDirectory: project.buildDirectory + "/bin"
    includeDependencies: ["QtCore", "QtCore-private"]

    Depends { name: "QtBootstrap" }

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "source"
        prefix: configure.sourcePath + "/qtbase/src/tools/moc/"
        files: [
            "token.cpp",
            "generator.cpp",
            "main.cpp",
            "moc.cpp",
            "parser.cpp",
            "preprocessor.cpp",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "shell32",
            "ole32",
        ]
    }
}
