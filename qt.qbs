import qbs
import qbs.File
import qbs.TextFile
import "qbs/imports/QtUtils.js" as QtUtils

Project {
    id: root
    name: "Qt"

    readonly property string version: QtUtils.qtVersion(sourceDirectory)
    readonly property string hostProfile: {
        if (hostMkspec !== targetMkspec || !qbs.architecture || !qbs.architecture.startsWith("x86"))
            print("You appear to be cross-compiling. Consider setting project.hostProfile to an appropriate profile for the host OS.");
        return profile;
    }
    readonly property stringList architectures: qbs.targetOS.contains("android") ? "armeabi" : undefined
    readonly property stringList targetProfiles: architectures
        ? architectures.map(function(a) { return profile + '_' + a; }) : profile
    readonly property string hostMkspec: QtUtils.detectHostMkspec(qbs.hostOS, qbs.toolchain)
    readonly property string targetMkspec: QtUtils.detectTargetMkspec(qbs.targetOS, qbs.toolchain, qbs.architecture)

    // Configuration
    readonly property var configDirectory: root.buildDirectory + "/.." // the directory Qt was configured in... this is normally the place Qt is built and also where it is installed for developer builds
    readonly property var configuration: {
        var configSummary = configDirectory + "/config.summary";
        if (!File.exists(configSummary)) {
            print("config.summary not found. Please run qt5's configure to generate a build configuration.");
        }
        var configContents = TextFile(configSummary).readAll();
        return configContents.match(/^  Configuration .......... (.*)$/m)[1].split(' ');
    }

    // Modules
    readonly property bool concurrent: configuration.contains("concurrent")
    readonly property bool dbus: configuration.contains("dbus")
    readonly property bool graphicaleffects: !configuration.contains("no-graphicaleffects")
    readonly property bool gui: !configuration.contains("no-gui")
    readonly property bool multimedia: !configuration.contains("no-multimedia")
    readonly property bool network: !configuration.contains("no-network")
    readonly property bool qml: !configuration.contains("no-qml")
    readonly property bool quick: !configuration.contains("no-quick")
    readonly property bool quickcontrols: !configuration.contains("no-quickcontrols")
    readonly property bool qmltest: !configuration.contains("no-qmltest")
    readonly property bool svg: !configuration.contains("no-svg")
    readonly property bool testlib: !configuration.contains("no-testlib")
    readonly property bool widgets: !configuration.contains("no-widgets")

    // Common
    readonly property bool cxx11: configuration.contains("c++11")
    readonly property bool sse2: configuration.contains("sse2")
    readonly property bool sse3: configuration.contains("sse3")
    readonly property bool ssse3: configuration.contains("ssse3")
    readonly property bool sse4_1: configuration.contains("sse4_1")
    readonly property bool sse4_2: configuration.contains("sse4_2")
    readonly property bool avx: configuration.contains("avx")
    readonly property bool avx2: configuration.contains("avx2")
    readonly property bool neon: configuration.contains("neon")
    readonly property bool private_tests: configuration.contains("private_tests")
    readonly property bool rpath: configuration.contains("rpath")
    readonly property bool reduce_exports: configuration.contains("reduce_exports")
    readonly property bool reduce_relocations: configuration.contains("reduce_relocations")

    // QtCore
    readonly property bool glib: configuration.contains("glib")
    readonly property bool iconv: configuration.contains("iconv")
    readonly property bool icu: configuration.contains("icu")
    readonly property bool harfbuzz: configuration.contains("harfbuzz")
    readonly property bool inotify: configuration.contains("inotify")
    readonly property bool pcre: configuration.contains("pcre")
    readonly property bool zlib: configuration.contains("zlib")
    readonly property bool system_zlib: configuration.contains("system-zlib")

    // QtNetwork
    readonly property bool getaddrinfo: configuration.contains("getaddrinfo")
    readonly property bool getifaddrs: configuration.contains("getifaddrs")
    readonly property bool ipv6ifname: configuration.contains("ipv6ifname")
    readonly property bool libproxy: configuration.contains("libproxy")
    readonly property bool openssl: configuration.contains("openssl")
    readonly property bool ssl: configuration.contains("ssl") || configuration.contains("openssl")

    // QtGui
    readonly property bool accessibility: configuration.contains("accessibility")
    readonly property bool alsa: configuration.contains("alsa")
    readonly property bool angle: configuration.contains("angle")
    readonly property bool atspi_bridge: configuration.contains("atspi-bridge")
    readonly property bool cursor: !configuration.contains("no-cursor")
    readonly property bool egl: configuration.contains("egl")
    readonly property bool evdev: configuration.contains("evdev")
    readonly property bool freetype: configuration.contains("freetype")
    readonly property bool eglfs_viv: configuration.contains("eglfs_viv")
    readonly property bool eglfs_brcm: configuration.contains("eglfs_brcm")
    readonly property bool eglfs_mali: configuration.contains("eglfs_mali")
    readonly property bool jpeg: configuration.contains("jpeg")
    readonly property bool kms: configuration.contains("kms")
    readonly property bool libinput: configuration.contains("libinput")
    readonly property bool libudev: configuration.contains("libudev")
    readonly property bool linuxfb: configuration.contains("linuxfb")
    readonly property bool mtdev: configuration.contains("mtdev")
    readonly property bool opengl: configuration.contains("opengl") && !opengles2
    readonly property bool opengles2: configuration.contains("opengles2")
    readonly property bool png: configuration.contains("png")
    readonly property bool system_freetype: configuration.contains("system-freetype")
    readonly property bool system_jpeg: configuration.contains("system-jpeg")
    readonly property bool system_png: configuration.contains("system-png")
    readonly property bool xcb: configuration.contains("xcb")
    readonly property bool xcb_glx: configuration.contains("xcb-glx")
    readonly property bool xcb_xlib: configuration.contains("xcb-xlib")
    readonly property bool xcb_sm: configuration.contains("xcb-sm")
    readonly property bool xkb: configuration.contains("xkb")

    // QtPrintSupport
    readonly property bool cups: configuration.contains("cups")

    // QtWidgets
    readonly property bool androidstyle: configuration.contains("androidstyle")
    readonly property bool gtkstyle: configuration.contains("gtkstyle")
    readonly property bool windowscestyle: configuration.contains("windowscestyle")
    readonly property bool windowsmobilestyle: configuration.contains("windowsmobilestyle")
    readonly property bool windowsvistastyle: configuration.contains("windowsvistastyle")
    readonly property bool windowsxpstyle: configuration.contains("windowsxpstyle")

    // QtMultimedia
    readonly property bool gstreamer_0_10: configuration.contains("gstreamer-0.10")
    readonly property bool pulseaudio: configuration.contains("pulseaudio")


    qbsSearchPaths: ["qbs", "headers"]
    minimumQbsVersion: "1.4.0"

    references: [
        "headers/headers.qbs",
        "3rdparty/3rdparty.qbs",
    ]

    Project {
        name: "lib"
        references: [
            "qtbootstrap.qbs",
            "qtcore.qbs",
            "qtgui.qbs",
            "qtnetwork.qbs",
            "qtmultimedia.qbs",
            "qtmultimediaquicktools.qbs",
            "qtqml.qbs",
            "qtquick.qbs",
            "qttest.qbs",
            "qtwidgets.qbs",
            /*"qtmultimediawidgets.qbs",
            "qtquickcontrols.qbs",
            "qtquicktest.qbs",
            "qtsvg.qbs",
            "gsttools.qbs",*/
        ]
    }

    Project {
        name: "tools"

        references: [
            "tools/moc.qbs",
            "tools/rcc.qbs",
            "tools/lrelease.qbs",
            "tools/uic.qbs",
        ]
    }

    Project {
        name: "plugins"

        Project {
            name: "platforms"
            references: [
                "plugins/platforms/eglfs.qbs",
                "plugins/platforms/xcb.qbs",
                "plugins/platforms/windows.qbs",
                "plugins/platforms/winrt.qbs",
            ]
        }

        Project {
            name: "input"
            references: [
                "plugins/input/evdevtouch.qbs",
            ]
        }

        Project {
            name: "mediaservice"
            references: [
                "plugins/mediaservice/gstreamer-camerabin.qbs",
            ]
        }

        Project {
            name: "videonode"
            references: [
                "plugins/video/videonode-egl.qbs",
                "plugins/video/videonode-imx6.qbs",
            ]
        }
    }

    Project {
        name: "imports"
        references: [
            "qml/qtquick2.qbs",
            "qml/qtquick2window.qbs",
            "qml/qtgraphicaleffects.qbs", // here because it doesn't contain a module
            "qml/declarative_multimedia.qbs",
        ]
    }
}
