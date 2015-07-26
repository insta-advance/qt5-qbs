import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/dbus/"
    files: "**/*.h"
    excludeFiles: "doc/**"
}
