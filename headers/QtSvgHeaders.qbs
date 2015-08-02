import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtsvg/src/svg/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
