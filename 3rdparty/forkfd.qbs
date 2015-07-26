import qbs

Product {
    type: "hpp"

    Depends { name: "cpp" }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            project.sourceDirectory + "/qtbase/src/3rdparty/forkfd",
        ]
    }
}
