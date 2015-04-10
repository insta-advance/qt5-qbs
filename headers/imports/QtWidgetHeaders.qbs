import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtbase/src/widgets/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
