import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtmultimedia/src/multimediawidgets/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
