import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/concurrent/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
