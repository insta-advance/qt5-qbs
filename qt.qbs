import qbs
import qbs.File
import qbs.TextFile
import "qbs/imports/QtUtils.js" as QtUtils

Project {
    id: root
    name: "Qt"

    readonly property string configuration: "qtconfig.json"
    readonly property string sourcePath: sourceDirectory
    readonly property string version: QtUtils.qtVersion(sourcePath)
    readonly property bool developerBuild: false

    qbsSearchPaths: ["qbs", "headers"]
    minimumQbsVersion: "1.4.0"

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
