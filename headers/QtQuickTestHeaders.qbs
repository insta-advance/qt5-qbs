import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtdeclarative/src/qmltest/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
