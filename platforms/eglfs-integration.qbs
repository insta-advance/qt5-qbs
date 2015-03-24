import qbs
import qbs.ModUtils
import qbs.Probes
import "../qbs/utils.js" as Utils

QtModule {
    condition: configure.egl
    name: "QtEglDeviceIntegration"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    cpp.defines: {
        var defines = base.concat([
            "QT_BUILD_EGL_DEVICE_LIB",
            "MESA_EGL_NO_X11_HEADERS",
            "QT_NO_EVDEV", // ### build the evdev plugins separately
            "EGL_API_FB", // ### from imx6, not sure if this is compatible. we want to build an ARM binary that works with multiple boards
        ]);

        if (!configure.cursor)
            defines.push("QT_NO_CURSOR");

        if (!configure.glib)
            defines.push("QT_NO_GLIB");

        return defines;
    }

    cpp.dynamicLibraries: base.concat([
        "pthread",
    ]);

    cpp.includePaths: base.concat([
        project.sourcePath + "/qtbase/src/3rdparty/freetype/include", // ### use Probe for system freetype
    ])

    Depends { name: "egl" }
    Depends { name: "glib"; condition: configure.glib }
    Depends { name: "opengl" }
    Depends { name: "udev"; condition: configure.udev }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }

    Group {
        name: "headers"
        prefix: project.sourcePath + "/qtbase/src/"
        files: {
            var files = [
                "plugins/platforms/eglfs/qeglfscontext.h",
                "plugins/platforms/eglfs/qeglfsdeviceintegration.h",
                "plugins/platforms/eglfs/qeglfshooks.h",
                "plugins/platforms/eglfs/qeglfsintegration.h",
                "plugins/platforms/eglfs/qeglfsoffscreenwindow.h",
                "plugins/platforms/eglfs/qeglfsscreen.h",
                "plugins/platforms/eglfs/qeglfswindow.h",
                "platformsupport/eglconvenience/qeglplatformcursor_p.h", // ### to be excluded for QT_NO_CURSOR
                "platformsupport/eventdispatchers/qunixeventdispatcher_qpa_p.h",
                "platformsupport/fbconvenience/qfbvthandler_p.h",
                "platformsupport/platformcompositor/qopenglcompositorbackingstore_p.h",
                "platformsupport/platformcompositor/qopenglcompositor_p.h",
            ];

            if (configure.glib) {
                files.push("platformsupport/eventdispatchers/qeventdispatcher_glib_p.h");
            }

            if (configure.udev) {
                files.push("platformsupport/devicediscovery/qdevicediscovery_p.h");
                files.push("platformsupport/devicediscovery/qdevicediscovery_udev_p.h");
            }

            return files;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/"
        files: {
            var files = [
                "plugins/platforms/eglfs/qeglfscontext.cpp",
                "plugins/platforms/eglfs/qeglfsdeviceintegration.cpp",
                "plugins/platforms/eglfs/qeglfshooks.cpp",
                "plugins/platforms/eglfs/qeglfsintegration.cpp",
                "plugins/platforms/eglfs/qeglfsoffscreenwindow.cpp",
                "plugins/platforms/eglfs/qeglfsscreen.cpp",
                "plugins/platforms/eglfs/qeglfswindow.cpp",
                "platformsupport/eglconvenience/qeglconvenience.cpp",
                "platformsupport/eglconvenience/qeglpbuffer.cpp",
                "platformsupport/eglconvenience/qeglplatformcursor.cpp", // ### QT_NO_CURSOR
                "platformsupport/eglconvenience/qeglplatformcontext.cpp",
                "platformsupport/eglconvenience/qeglplatformintegration.cpp",
                "platformsupport/eglconvenience/qeglplatformscreen.cpp",
                "platformsupport/eglconvenience/qeglplatformwindow.cpp",
                "platformsupport/eventdispatchers/qgenericunixeventdispatcher.cpp",
                "platformsupport/eventdispatchers/qunixeventdispatcher.cpp",
                "platformsupport/fbconvenience/qfbvthandler.cpp",
                "platformsupport/fontdatabases/basic/qbasicfontdatabase.cpp",
                "platformsupport/platformcompositor/qopenglcompositorbackingstore.cpp",
                "platformsupport/platformcompositor/qopenglcompositor.cpp",
                "platformsupport/services/genericunix/qgenericunixservices.cpp",
            ];

            if (configure.udev) {
                files.push("platformsupport/devicediscovery/qdevicediscovery_udev.cpp");
            }

            if (configure.glib) {
                files.push("platformsupport/eventdispatchers/qeventdispatcher_glib.cpp");
            }

            // ### QT_NO_EVDEV
            /*"platformsupport/input/evdevmouse/*.cpp",
            "platformsupport/input/evdevkeyboard/*.cpp",
            "platformsupport/input/evdevtouch/*.cpp",
            "platformsupport/input/tslib/*.cpp",*/

            return files;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        condition: configure.cursor
        name: "cursor.qrc"
        files: project.sourcePath + "/qtbase/src/plugins/platforms/eglfs/cursor.qrc"
        fileTags: "qrc"
    }
}
