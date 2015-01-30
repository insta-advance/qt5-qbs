import qbs
import qbs.File

Project {
    id: root

    property string host: {
        var host;
        if (qbs.targetOS.contains("linux")) {
            if (qbs.toolchain.contains("clang"))
                host = "linux-clang";
            else if (qbs.toolchain.contains("gcc"))
                host = "linux-g++";
        } else if (qbs.targetOS.contains("windows")) {
            if (qbs.toolchain.contains("mingw"))
                host = "win32-g++";
            else if (qbs.toolchain.contains("msvc"))
                host = "win32-msvc2013";
        }
        return host;
    }

    qbsSearchPaths: "qbs"

    references: [
        "qbs/qhost/qhost.qbs",
        "qbs/qtbase/qtbootstrap.qbs",
        "qbs/qtbase/tools/moc.qbs",
        "qbs/qtbase/tools/rcc.qbs",
        "qbs/qttools/linguist/lrelease.qbs",
    ]
}
