import qbs

Product {
    type: "hpp"
    profiles: project.targetProfiles

    Depends { name: "cpp" }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            project.sourceDirectory + "/qtbase/src/3rdparty/forkfd",
        ]
    }
}
