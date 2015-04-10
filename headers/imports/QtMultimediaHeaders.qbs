import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtmultimedia/src/multimedia/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
