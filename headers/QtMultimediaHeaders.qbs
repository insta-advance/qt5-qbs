import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtmultimedia/src/multimedia/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
