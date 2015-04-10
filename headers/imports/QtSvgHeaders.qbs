import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtsvg/src/svg/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
