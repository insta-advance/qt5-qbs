import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtdeclarative/src/quick/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
