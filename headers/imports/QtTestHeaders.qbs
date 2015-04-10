import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/testlib/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
