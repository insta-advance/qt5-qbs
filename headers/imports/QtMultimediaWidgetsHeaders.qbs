import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtmultimedia/src/multimediawidgets/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
