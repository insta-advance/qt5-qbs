import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/widgets/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
