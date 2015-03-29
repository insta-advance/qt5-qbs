import qbs
import qbs.File
import qbs.TextFile
import "qbs/imports/QtUtils.js" as QtUtils

Project {
    id: root
    name: "Qt"

    readonly property path sourcePath: sourceDirectory
    readonly property string version: QtUtils.qtVersion(sourcePath)

    qbsSearchPaths: ["qbs", "headers"]

    references: [
        "3rdparty/3rdparty.qbs",
        "headers/headers.qbs",
        "qtcore.qbs",
        "qtgui.qbs",
        "qtmultimedia.qbs",
        "qtnetwork.qbs",
        "qtqml.qbs",
        "qtquick.qbs",
        "qtquickcontrols.qbs",
        "qtsvg.qbs",
        "qtwidgets.qbs",
    ]
}
