import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/platformsupport/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
