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
        prefix: project.sourceDirectory + "/qttools/src/androiddeployqt/"
        files: [
            "main.cpp",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.cxxFlags: "-U__STRICT_ANSI__"
    }
}

