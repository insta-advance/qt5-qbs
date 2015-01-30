import qbs

CppApplication {
    name: "rcc"

    destinationDirectory: project.buildDirectory + "/bin"

    Depends { name: "QtBootstrap" }
    Depends { name: "QtHost.includes" }
    QtHost.includes.modules: [ "core" ]

    cpp.includePaths: base.concat([
        project.sourceDirectory + "/qtbase/src/tools/rcc",
    ])

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "source"
        prefix: project.sourceDirectory + "/qtbase/src/tools/rcc/"
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
