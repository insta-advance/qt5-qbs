import qbs

QtProduct {
    type: "application"
    destinationDirectory: project.buildDirectory + "/bin"
    files: "qhost_main.cpp"

    cpp.cxxFlags: "-std=c++11"

    includeDependencies: ["QtCore"]

    Depends { name: "QtBootstrap" }

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }
}
