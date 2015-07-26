import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/testlib/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
