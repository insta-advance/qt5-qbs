import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/gui/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
