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

    qbsSearchPaths: ["qbs", "headers"]

    references: [
        "3rdparty/3rdparty.qbs",
        "install.qbs",
        "headers/headers.qbs",
        "qtcore.qbs",
        "qtgui.qbs",
        "qtnetwork.qbs",

        "qtqml.qbs",
        "qtquick.qbs",

        "qtmultimedia.qbs",
        "multimedia-support.qbs",

        "imports/imports.qbs",
    ]

    Project {
        name: "plugins"
        references: [
            "plugins/platforms/eglfs.qbs",
        ]

        Project {
            name: "mediaservice"
            references: [
                "plugins/mediaservice/gstreamer-camerabin.qbs",
            ]
        }

        Project {
            name: "video"
            references: [
                "plugins/video/videonode-egl.qbs",
                "plugins/video/videonode-imx6.qbs",
            ]
        }
    }
}
