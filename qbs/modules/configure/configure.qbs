import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile
import qbs.Probes

Module {
    id: configureModule

    // Essentials

    // Modules
    readonly property bool concurrent: properties.concurrent
    readonly property bool dbus: properties.dbus
    readonly property bool graphicaleffects: properties.graphicaleffects
    readonly property bool gui: properties.gui
    readonly property bool multimedia: properties.multimedia
    readonly property bool network: properties.network
    readonly property bool qml: properties.qml
    readonly property bool quick: properties.quick
    readonly property bool quickcontrols: properties.quickcontrols
    readonly property bool svg: properties.svg
    readonly property bool widgets: properties.widgets

    // Common
    readonly property string prefix: properties.prefix
    readonly property string mkspec: properties.mkspec
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
    readonly property bool xkb: properties.xkb
    readonly property bool linuxfb: properties.linuxfb
    readonly property string png: properties.png
    readonly property string jpeg: properties.jpeg
    readonly property string freetype: properties.freetype
    readonly property string qpa: properties.qpa

    // QtWidgets
    readonly property bool android: properties.androidstyle
    readonly property bool gtkstyle: properties.gtkstyle
    readonly property bool windowscestyle: properties.windowscestyle
    readonly property bool windowsmobilestyle: properties.windowsmobilestyle
    readonly property bool windowsvistastyle: properties.windowsvistastyle
    readonly property bool windowsxpstyle: properties.windowsxpstyle

    // QtMultimedia
    readonly property bool gstreamer: properties.gstreamer

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

    Probe {
        id: openglProbe
        property string version
        condition: configureModule.opengl === undefined
        configure: {
            if (!condition)
                return;
        }
    }

    readonly property var properties: {
        var config = { };
        if (project.name == "qt-host-tools")
            return { mkspec: project.host };
        if (!project.configuration.length) // allow for a null configuration
            return config;
        var filePaths = [
            project.configuration, // user-provided
            project.sourceDirectory + '/' + project.configuration,
            qbs.qtconfig, // profile-installed
            project.sourceDirectory + '/' + project.profile + '-' + qbs.buildVariant + "/qtconfig.json", // auto-generated
        ];
        // Loop through each file option in order of precedence to find the configuration.
        for (var i in filePaths) {
            var filePath = filePaths[i];
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
                return JSON.parse(configContents);
            }
        }
        throw "You have not specified a configuration file. "
            + "Please add qtconfig.json to the source directory "
            + "or pass 'project.configuration:<file-name>'. "
            + "You may run 'qbs -f qt-configure.qbs to generate a new configuration. "
            + "If you do not want to use a configuration file, pass 'project.configuration:null'.";
    }
}
