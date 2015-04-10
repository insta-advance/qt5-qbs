import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/platformheaders/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
