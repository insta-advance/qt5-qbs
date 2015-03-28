import qbs

QtProduct {
    type: "application"

    destinationDirectory: project.buildDirectory + "/bin"

    includeDependencies: ["QtCore"]

    Depends { name: "QtBootstrap" }

    cpp.includePaths: [
        configure.sourcePath + "/qtbase/src/tools/rcc",
    ].concat(base)

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "source"
        prefix: configure.sourcePath + "/qtbase/src/tools/rcc/"
        files: [
            "main.cpp",
            "rcc.cpp",
            "rcc.h",
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
