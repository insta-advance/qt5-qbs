import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/xml/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
