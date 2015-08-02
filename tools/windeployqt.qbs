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
        prefix: project.sourceDirectory + "/qttools/src/windeployqt/"
        files: [
            "elfreader.cpp",
            "main.cpp",
            "qmlutils.cpp",
            "utils.cpp",
        ]
    }
}
