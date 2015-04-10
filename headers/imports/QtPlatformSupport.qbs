import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/platformsupport/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
