import qbs

QtLibrary {
    targetName: "Qt5" + name.slice(2)

    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "QtHost.sync" }
    QtHost.sync.module: name

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary", "dynamiclibrary_import", "staticlibrary"]
        qbs.install: true
        qbs.installDir: "lib"
    }
}
