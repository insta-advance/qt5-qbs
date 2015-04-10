import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtdeclarative/src/quick/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
