import qbs
import qbs.ModUtils
import qbs.Probes
import "../qbs/utils.js" as Utils

QtModule {
    name: "QtXcbQpa"
    condition: configure.xcb

    readonly property path basePath: project.sourcePath + "/qtbase/src/plugins/platforms/xcb"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    readonly property stringList defines: {
        var defines = [];
        if (!configure.dbus) {
            defines.push("QT_NO_DBUS");
            defines.push("QT_NO_ACCESSIBILITY_ATSPI_BRIDGE");
        }
        if (!configure.xkb)
            defines.push("QT_NO_XKB");
        if (!configure.cursor)
            defines.push("QT_NO_CURSOR");
        if (!configure.glib)
            defines.push("QT_NO_GLIB");
        return defines;
    }

    cpp.defines: base.concat([
        "QT_BUILD_XCB_DEVICE_LIB",
        "MESA_EGL_NO_X11_HEADERS",
    ]).concat(product.defines)

    cpp.dynamicLibraries: base.concat([
        "pthread",
        "dl",
    ]).concat(Utils.dynamicLibraries(xcbImageProbe.libs)).concat(
              Utils.dynamicLibraries(xcbKeysymsProbe.libs)).concat(
              Utils.dynamicLibraries(xcbRandrProbe.libs)).concat(
              Utils.dynamicLibraries(xcbSyncProbe.libs)).concat(
              Utils.dynamicLibraries(xcbIcccmProbe.libs)).concat(
              Utils.dynamicLibraries(xcbXfixesProbe.libs))


    cpp.includePaths: base.concat([
        basePath,
        basePath + "/gl_integrations",
        project.sourcePath + "/qtbase/src/3rdparty/freetype/include", // ### use Probe for system freetype
    ])

    // ### move these to the xcb-x11 depends project
    Probes.PkgConfigProbe {
        id: xcbImageProbe
        name: "xcb-image"
    }

    Probes.PkgConfigProbe {
        id: xcbXfixesProbe
        name: "xcb-xfixes"
    }

    Probes.PkgConfigProbe {
        id: xcbRandrProbe
        name: "xcb-randr"
    }

    Probes.PkgConfigProbe {
        id: xcbSyncProbe
        name: "xcb-sync"
    }

    Probes.PkgConfigProbe {
        id: xcbKeysymsProbe
        name: "xcb-keysyms"
    }

    Probes.PkgConfigProbe {
        id: xcbIcccmProbe
        name: "xcb-icccm"
    }

    Depends { name: "egl" }
    Depends { name: "xcb-x11" }
    Depends { name: "xkbcommon" }
    Depends { name: "glib"; condition: configure.glib }
    Depends { name: "opengl" }
    Depends { name: "udev"; condition: configure.udev }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: [
            "*.h",
            "gl_integrations/*.h",
            "../../../platformsupport/eventdispatchers/qgenericunixeventdispatcher_p.h",
            "../../../platformsupport/eventdispatchers/qunixeventdispatcher_qpa_p.h",
            "../../../platformsupport/themes/genericunix/qgenericunixthemes_p.h",
            "../../../platformsupport/services/genericunix/qgenericunixservices.cpp",
        ]
        excludeFiles: {
            var excludeFiles = [];
            if (!configure["xcb-sm"])
                excludeFiles.push("qxcbsessionmanager.h");
            return excludeFiles;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "*.cpp",
            "gl_integrations/*.cpp",
            "../../../platformsupport/eventdispatchers/qgenericunixeventdispatcher.cpp",
            "../../../platformsupport/eventdispatchers/qunixeventdispatcher.cpp",
            "../../../platformsupport/themes/genericunix/qgenericunixthemes.cpp",
            "../../../platformsupport/fontdatabases/basic/qbasicfontdatabase.cpp",
        ]
        excludeFiles: {
            var excludeFiles = [];
            if (!configure["xcb-sm"])
                excludeFiles.push("qxcbsessionmanager.cpp");
            return excludeFiles;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: product.basePath + "/gl_integrations"
        cpp.defines: product.defines
    }
}
