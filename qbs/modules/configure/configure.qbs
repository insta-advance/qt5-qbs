import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile

Module {
    // configuration options -- use var also for boolean values which are initially undefined
    property bool shared: true // ### allow for static builds as well
    property int pointerSize: qbs.architecture == "x86_64" ? 8 : 4
    property string qreal: properties.qreal !== undefined ? properties.qreal : "double"
    // ### add and fix these in QtCore
    property bool sse2: properties.sse2 !== undefined ? properties.sse2 : true
    property bool sse3: properties.sse3 !== undefined ? properties.sse3 : true
    property bool ssse3: properties.ssse3 !== undefined ? properties.ssse3 : true
    property bool sse4_1: properties.sse4_1 !== undefined ? properties.sse4_1 : true
    property bool sse4_2: properties.sse4_2 !== undefined ? properties.sse4_2 : true
    property bool avx: properties.avx !== undefined ? properties.avx : true
    property bool avx2: properties.avx2 !== undefined ? properties.avx2 : true

    // QtCore
    property var glib: properties.glib
    property var iconv: properties.iconv

    // QtGui
    property bool cursor: properties.cursor !== undefined ? properties.cursor : true
    property var png: properties.png !== undefined ? properties.png : "qt"
    property var opengl: properties.opengl
    property var qpa: properties.qpa
    property var udev: properties.udev

    // input from user
    property path propertiesFile: "qtconfig.json"
    readonly property var properties: {
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
            return JSON.parse(configContents);
        }
        return { };
    }

    readonly property stringList config: {
        var config = [];
        for (var i in properties) {
            if (properties[i])
                config.push(i);
        }
        config.push(shared ? "shared" : "static");
        config.push(qbs.buildVariant);
        if (sse2)
            config.push("sse2");
        if (sse3)
            config.push("sse3");
        if (ssse3)
            config.push("ssse3");
        if (sse4_1)
            config.push("sse4_1");
        if (sse4_2)
            config.push("sse4_2");
        if (avx)
            config.push("avx");
        if (avx2)
            config.push("avx2");
        if (glib)
            config.push("glib");
        if (iconv)
            config.push("iconv");
        if (cursor)
            config.push("cursor");
        if (png)
            config.push("png");
        if (opengl)
            config.push("opengl"); // ### add opengl type
        if (qpa)
            config.push("qpa");
        if (udev)
            config.push("udev");
    }

    // ###todo: consider adding cxxFlags/linkerFlags here as well

    // Trivial flags which would otherwise trigger a QT_NO_XXX definition should
    // have a default assigned above. Otherwise, a lower module may end up
    // with a conflicting definition in a higher module.
    readonly property stringList defines: {
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