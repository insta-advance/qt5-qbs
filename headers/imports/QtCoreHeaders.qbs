import qbs

Group {
    name: "headers"
    files: [
        project.sourceDirectory + "/qtbase/src/corelib/**/*.h",
        project.configDirectory + "/src/corelib/global/qconfig.h",
        project.configDirectory + "/src/corelib/global/qfeatures.h",
    ]
    excludeFiles: "doc/**"
}
