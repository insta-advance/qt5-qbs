import qbs 1.0
import qbs.TextFile
import qbs.Process

Project {
    id: root

    property string target: {
        var host;
        if (qbs.targetOS.contains("linux")) {
            if (qbs.toolchain.contains("clang"))
                host = "linux-clang";
            else if (qbs.toolchain.contains("gcc"))
                host = "linux-g++";
        } else if (qbs.targetOS.contains("winphone")) {
            switch (qbs.architecture) {
            case "x86":
                host = "winphone-x86-msvc2013";
                break;
            case "x86_64":
                host = "winphone-x64-msvc2013";
                break;
            case "arm":
                host = "winphone-arm-msvc2013";
                break;
            }
        } else if (qbs.targetOS.contains("winrt")) {
            switch (qbs.architecture) {
            case "x86":
                host = "winrt-x86-msvc2013";
                break;
            case "x86_64":
                host = "winrt-x64-msvc2013";
                break;
            case "arm":
                host = "winrt-arm-msvc2013";
                break;
            }
        } else if (qbs.targetOS.contains("windows")) {
            if (qbs.toolchain.contains("mingw"))
                host = "win32-g++";
            else if (qbs.toolchain.contains("msvc"))
                host = "win32-msvc2013";
        }
        return host;
    }

    property string qtVersion: "5.5.0"
    property int pointerSize: qbs.architecture == "x86_64" ? 8 : 4

    qbsSearchPaths: ["qbs", "headers"]

    references: [
        "3rdparty/3rdparty.qbs",
        "configure.qbs",
        "headers/headers.qbs",
        "qtcore.qbs",
        "qtgui.qbs",
        "qtnetwork.qbs",
        "qtmultimedia.qbs",

        "qtqml.qbs",
        "qtquick.qbs",

        "imports/imports.qbs",
    ]

    Project {
        name: "plugins"
        references: [
            "plugins/platforms/platforms.qbs",
            "plugins/multimedia/multimedia.qbs",
        ]
    }
}
