import qbs

QtHostTool {
    type: "application"
    destinationDirectory: project.buildDirectory + "/bin"

    Depends { name: "QtBootstrap" }
    Depends { name: "QtCoreHeaders" }

    cpp.defines: [
        "QT_UIC",
        "QT_UIC_CPP_GENERATOR",
    ].concat(base)

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/tools/uic",
        project.sourceDirectory + "/qtbase/src/tools/uic/cpp",
    ].concat(base)

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
        prefix: project.sourceDirectory + "/qtbase/src/tools/uic/"
        files: [
            "*.h",
            "cpp/*.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/tools/uic/"
        files: [
            "*.cpp",
            "cpp/*.cpp",
        ]
    }
}
