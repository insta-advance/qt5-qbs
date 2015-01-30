import qbs

QtLibrary {
    property path includeDirectory: project.buildDirectory + "/include"
    property string category

    destinationDirectory: project.buildDirectory + "/plugins/" + category

    Group {
        fileTagsFilter: ["debuginfo", "dynamiclibrary"]
        qbs.install: true
        qbs.installDir: "plugins/" + category
    }
}
