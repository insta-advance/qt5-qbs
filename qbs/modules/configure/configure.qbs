import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile

Module {
    // Modules
    readonly property bool concurrent: properties.concurrent
    readonly property bool dbus: properties.dbus
    readonly property bool gui: properties.gui
    readonly property bool widgets: properties.widgets
    readonly property bool network: properties.network
    readonly property bool qml: properties.qml
    readonly property bool quick: properties.quick
    readonly property bool multimedia: properties.multimedia

    // Common
    readonly property string prefix: properties.prefix
    readonly property bool cxx11: properties["c++11"]
    readonly property bool sse2: properties.sse2
    readonly property bool sse3: properties.sse3
    readonly property bool ssse3: properties.ssse3
    readonly property bool sse4_1: properties.sse4_1
    readonly property bool sse4_2: properties.sse4_2
    readonly property bool avx: properties.avx
    readonly property bool avx2: properties.avx2
    readonly property bool neon: properties.neon

    // QtCore
    readonly property bool glib: properties.glib
    readonly property bool iconv: properties.iconv
    readonly property bool harfbuzz: properties.harfbuzz
    readonly property bool inotify: properties.inotify
    readonly property bool pcre: properties.pcre
    readonly property bool zlib: properties.zlib

    // QtNetwork
    readonly property bool getaddrinfo: properties.getaddrinfo
    readonly property bool getifaddrs: properties.getifaddrs
    readonly property bool ipv6ifname: properties.ipv6ifname

    // QtGui
    readonly property bool accessibility: properties.accessibility
    readonly property bool cursor: properties.cursor
    readonly property bool egl: properties.egl
    readonly property bool evdev: properties.evdev
    readonly property bool opengl: properties.opengl
    readonly property bool udev: properties.udev
    readonly property bool imx6: properties.imx6
    readonly property bool kms: properties.kms
    readonly property bool xcb: properties.xcb
    readonly property bool linuxfb: properties.linuxfb
    readonly property string png: properties.png
    readonly property string qpa: properties.qpa
    // xcb-qt
    // xcbcommon

    // QtWidgets
    readonly property bool android: properties.androidstyle
    readonly property bool gtkstyle: properties.gtkstyle
    readonly property bool windowsvistastyle: properties.windowsvistastyle

    // QtMultimedia
    readonly property bool gstreamer: properties.gstreamer

    // input from user
    readonly property path propertiesFile: "qtconfig-" + project.profile + ".json"
    readonly property var properties: {
        // For settings which shouldn't default to false
        var config = {
            // modules are true by default
            gui: true,
            network: true,
            widgets: true,
            qml: true,
            quick: true,
            multimedia: true,

            // default config
            prefix: qbs.installRoot ? qbs.installRoot : project.buildDirectory,

            "c++11": true, // ### compiler/version test?

            pcre: true,
            zlib: true,

            png: "qt",
            qpa: "xcb", // ### fix me for other platforms
            accessibility: true,
            cursor: true,
            freetype: true,

            androidstyle: qbs.targetOS.contains("android"),
            windowsvistastyle: qbs.targetOS.contains("windows"),
        };

        // ### in the case that there is a Qt attached to this profile, get these from Qt.core.config
        var filePath = FileInfo.isAbsolutePath(propertiesFile)
                       ? propertiesFile
                       : project.sourceDirectory + '/' + propertiesFile;
        if (File.exists(filePath)) {
            var configFile = new TextFile(filePath);
            var configContents = "";
            while (!configFile.atEof()) {
                var line = configFile.readLine();
                // Comments aren't valid JSON, but allow (and remove) them anyway
                line = line.replace(/ +\/\/.*$/g, '');
                configContents += line;
            }
            configFile.close();
            // Allow a trailing comma
            configContents = configContents.replace(/, *\}$/, '}');
            var json = JSON.parse(configContents);
            for (var i in json)
                config[i] = json[i];
        }
        return config;
    }

    readonly property stringList baseDefines: [
        "QT_ASCII_CAST_WARNINGS",
        "QT_DEPRECATED_WARNINGS",
        "QT_DISABLE_DEPRECATED_BEFORE=0x040800",
        "QT_POINTER_SIZE=" + (qbs.architecture == "x86_64" ? 8 : 4),
        "QT_USE_QSTRINGBUILDER",
    ]

    readonly property stringList simdDefines: {
        var defines = [];
        if (sse2)
            defines.push("QT_COMPILER_SUPPORTS_SSE2=1");
        if (sse3)
            defines.push("QT_COMPILER_SUPPORTS_SSE3=1");
        if (ssse3)
            defines.push("QT_COMPILER_SUPPORTS_SSSE3=1");
        if (sse4_1)
            defines.push("QT_COMPILER_SUPPORTS_SSE4_1=1");
        if (sse4_2)
            defines.push("QT_COMPILER_SUPPORTS_SSE4_2=1");
        if (avx)
            defines.push("QT_COMPILER_SUPPORTS_AVX=1");
        if (avx2)
            defines.push("QT_COMPILER_SUPPORTS_AVX2=1");
        if (neon)
            defines.push("QT_COMPILER_SUPPORTS_NEON=1");
        return defines;
    }

    readonly property stringList openglDefines: {
        var defines = [];
        if (opengl) {
            defines.push("QT_OPENGL");
            switch (opengl) {
            case "es2":
                defines.push("QT_OPENGL_ES");
                defines.push("QT_OPENGL_ES_2");
                break;
            case "dynamic":
                defines.push("QT_OPENGL_DYNAMIC");
                break;
            }
        }
        return defines;
    }

    Depends { name: "cpp" }

    cpp.cxxFlags: {
        var cxxFlags = [];
        if (qbs.toolchain.contains("gcc")) {
            if (sse2)
                cxxFlags.push("-msse2");
            if (sse3)
                cxxFlags.push("-msse3");
            if (ssse3)
                cxxFlags.push("-mssse3");
            if (sse4_1)
                cxxFlags.push("-msse4.1");
            if (sse4_2)
                cxxFlags.push("-msse4.2");
            if (avx)
                cxxFlags.push("-mavx");
            if (avx2)
                cxxFlags.push("-mavx2");
            if (neon)
                cxxFlags.push("-mfpu=neon");
        }
        return cxxFlags;
    }
}
