import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/platformheaders/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
