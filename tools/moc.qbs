import qbs

CppApplication {
    profiles: project.hostProfile
    destinationDirectory: project.buildDirectory + "/bin"

    Depends { name: "Qt.bootstrap-private" }

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "source"
        prefix: project.sourceDirectory + "/qtbase/src/tools/moc/"
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
