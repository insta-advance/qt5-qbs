import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtdeclarative/src/qml/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
