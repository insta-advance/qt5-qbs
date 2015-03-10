import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile

Module {
    // Common
    readonly property bool shared: properties.shared
    readonly property int pointerSize: properties.pointerSize
    readonly property string qreal: properties.qreal
    readonly property string prefix: properties.prefix
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

    // QtGui
    readonly property bool cursor: properties.cursor
    readonly property bool egl: properties.egl
    readonly property bool opengl: properties.opengl
    readonly property bool udev: properties.udev
    readonly property bool imx6: properties.imx6
    readonly property bool kms: properties.kms
    readonly property bool x11: properties.x11
    readonly property string png: properties.png
    readonly property string qpa: properties.qpa

    // QtMultimedia
    readonly property bool gstreamer: properties.gstreamer

    // input from user
    readonly property path propertiesFile: "qtconfig-" + project.profile + ".json"
    readonly property var properties: {
        // For settings which shouldn't default to false
        var config = {
            shared: true,
            pointerSize: qbs.architecture == "x86_64" ? 8 : 4,
            qreal: "double",
            prefix: "/opt/Qt" + project.qtVersion,
            cursor: true,
            png: "qt",
            qpa: "xcb", // ### fix me for other platforms
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

    // For compatibility with qmake's CONFIG list
    readonly property stringList config: {
        var config = [];
        config.push(qbs.buildVariant);
        for (var i in properties) {
            if (properties[i])
                config.push(i);

        }
        if (opengl == "es2")
            config.push("opengles2");
        return config;
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

    // Trivial flags which would otherwise trigger a QT_NO_XXX definition should
    // have a default assigned above. Otherwise, a lower module may end up
    // with a conflicting definition in a higher module.
    cpp.defines: {
        var defines = [
            "QT_POINTER_SIZE=" + pointerSize,
            "QT_USE_QSTRINGBUILDER", // ### Qt won't build without this
            "QT_COORD_TYPE=" + qreal,
            'QT_COORD_TYPE_STRING="' + qreal + '"',
        ];

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

        // QtCore
        if (!glib)
            defines.push("QT_NO_GLIB");

        if (!iconv)
            defines.push("QT_NO_ICONV");

        // QtGui
        if (!cursor) {
            defines.push("QT_NO_CURSOR");
            defines.push("QT_NO_WHEELEVENT");
            defines.push("QT_NO_DRAGANDDROP");
        }

        if (png == "qt")
            defines.push("QT_USE_BUNDLED_LIBPNG");

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

        if (qpa)
            defines.push('QT_QPA_DEFAULT_PLATFORM_NAME="' + qpa + '"');

        return defines;
    }
}
