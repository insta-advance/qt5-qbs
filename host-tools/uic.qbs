import qbs

QtProduct {
    type: "application"

    destinationDirectory: project.buildDirectory + "/bin"

    includeDependencies: ["QtCore"]

    cpp.defines: base.concat([
        "QT_UIC",
        "QT_UIC_CPP_GENERATOR",
    ])

    cpp.includePaths: base.concat([
        project.sourcePath + "/qtbase/src/tools/uic",
        project.sourcePath + "/qtbase/src/tools/uic/cpp",
    ])

    Depends { name: "QtBootstrap" }

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

    Group {
        name: "headers"
        prefix: project.sourcePath + "/qtbase/src/tools/uic/"
        files: [
            "*.h",
            "cpp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/tools/uic/"
        files: [
            "*.cpp",
            "cpp/*.cpp",
        ]
    }
}
