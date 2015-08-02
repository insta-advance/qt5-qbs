import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtdeclarative/src/qml/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
