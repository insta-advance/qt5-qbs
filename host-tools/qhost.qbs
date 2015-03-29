import qbs

QtProduct {
    type: "application"
    destinationDirectory: project.buildDirectory + "/bin"

    includeDependencies: ["QtCore"]

    files: "qhost_main.cpp"

    Depends { name: "QtBootstrap" }

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cxxFlags: [
            "-std=c++11",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "shell32",
            "ole32",
        ]
    }

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }
}
