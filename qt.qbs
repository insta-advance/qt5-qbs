import qbs 1.0
import qbs.TextFile

Project {
    id: root
    name: "Qt"

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
        "qtwidgets.qbs",
    ]
}
