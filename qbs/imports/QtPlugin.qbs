import qbs

QtProduct {
    property string category

    type: "dynamiclibrary"
    destinationDirectory: project.buildDirectory + "/plugins/" + category

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary"]
        qbs.install: true
        qbs.installDir: "plugins/" + category
    }
}
