import qbs

CppApplication {
    destinationDirectory: project.buildDirectory + "/bin"
    files: "qhost_main.cpp"

    cpp.cxxFlags: "-std=c++11"

    Depends { name: "QtBootstrap" }
    Depends { name: "QtHost.includes" }
    QtHost.includes.modules: [ "core" ]

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }
}
