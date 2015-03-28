import qbs

QtProduct {
    type: "application"

    destinationDirectory: project.buildDirectory + "/bin"

    includeDependencies: ["QtCore"]

    cpp.defines: [
        "QT_UIC",
        "QT_UIC_CPP_GENERATOR",
    ].concat(base)

    cpp.includePaths: [
        configure.sourcePath + "/qtbase/src/tools/uic",
        configure.sourcePath + "/qtbase/src/tools/uic/cpp",
    ].concat(base)

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
        prefix: configure.sourcePath + "/qtbase/src/tools/uic/"
        files: [
            "*.h",
            "cpp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/tools/uic/"
        files: [
            "*.cpp",
            "cpp/*.cpp",
        ]
    }
}
