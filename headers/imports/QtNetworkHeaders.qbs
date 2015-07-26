import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/network/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
