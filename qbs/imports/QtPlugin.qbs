import qbs

QtLibrary {
    property string category

    destinationDirectory: project.buildDirectory + "/plugins/" + category

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary"]
        qbs.install: true
        qbs.installDir: "plugins/" + category
    }
}
