import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/network/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
