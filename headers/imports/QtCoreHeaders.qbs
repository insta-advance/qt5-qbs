import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/corelib/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
