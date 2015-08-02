import qbs

CppApplication {
    profiles: project.hostProfile
    destinationDirectory: project.buildDirectory + "/bin"

    Depends { name: "Qt.bootstrap-private" }

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/tools/rcc",
    ].concat(base)

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
