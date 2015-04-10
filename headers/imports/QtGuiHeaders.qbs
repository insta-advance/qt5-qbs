import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/gui/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
