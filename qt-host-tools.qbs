import qbs
import qbs.File
import qbs.TextFile
import "qbs/imports/QtUtils.js" as QtUtils

Project {
    name: "qt-host-tools"
    readonly property path sourcePath: qbs.getEnv("QT_SOURCE") || sourceDirectory
    readonly property string version: QtUtils.qtVersion(sourcePath)
    readonly property string mkspec: QtUtils.detectTargetMkspec(qbs.targetOS, qbs.toolchain, qbs.architecture)

    qbsSearchPaths: "qbs"

    references: [
        "host-tools/bootstrap-headers.qbs",
        "host-tools/lrelease.qbs",
        "host-tools/moc.qbs",
        "host-tools/qhost.qbs",
        "host-tools/qtbootstrap.qbs",
        "host-tools/rcc.qbs",
        "host-tools/uic.qbs",
    ]
}
