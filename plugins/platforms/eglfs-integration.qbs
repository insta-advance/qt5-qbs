import qbs
import qbs.Probes

QtModule {
    name: "QtEglDeviceIntegration"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    cpp.cxxFlags: udevProbe.cflags

    cpp.defines: [
        "QT_BUILD_EGL_DEVICE_LIB",
        "MESA_EGL_NO_X11_HEADERS",
        "QT_NO_EVDEV", // ### build the evdev plugins separately
    ]

    cpp.dynamicLibraries: {
        var libs = udevProbe.libs;
        for (var i in libs)
            libs[i] = libs[i].slice(2);
        return libs.concat(["EGL", "GLESv2"]);
    }

    cpp.includePaths: base.concat([
        project.sourceDirectory + "/qtbase/src/3rdparty/freetype/include", // ### use Probe for system freetype
    ])

    Probes.PkgConfigProbe {
        id: udevProbe
        name: "libudev"
    }

    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }

    Group {
        name: "headers"
        fileTags: "moc_hpp"
        prefix: project.sourceDirectory + "/qtbase/src/"
        files: [
            "plugins/platforms/eglfs/qeglfscontext.h",
            "plugins/platforms/eglfs/qeglfsdeviceintegration.h",
            "plugins/platforms/eglfs/qeglfshooks.h",
            "plugins/platforms/eglfs/qeglfsintegration.h",
            "plugins/platforms/eglfs/qeglfsoffscreenwindow.h",
            "plugins/platforms/eglfs/qeglfsscreen.h",
            "plugins/platforms/eglfs/qeglfswindow.h",
            "platformsupport/eglconvenience/qeglplatformcursor_p.h", // add to excluded for QT_NO_CURSOR
            "platformsupport/eventdispatchers/qunixeventdispatcher_qpa_p.h",
            "platformsupport/fbconvenience/qfbvthandler_p.h",
            "platformsupport/platformcompositor/qopenglcompositorbackingstore_p.h",
            "platformsupport/platformcompositor/qopenglcompositor_p.h",
            "platformsupport/devicediscovery/qdevicediscovery_p.h", // ### udev
            "platformsupport/devicediscovery/qdevicediscovery_udev_p.h",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/"
        files: [
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
            "platformsupport/devicediscovery/qdevicediscovery_udev.cpp",
            // ### QT_NO_EVDEV
            /*"platformsupport/input/evdevmouse/*.cpp",
            "platformsupport/input/evdevkeyboard/*.cpp",
            "platformsupport/input/evdevtouch/*.cpp",
            "platformsupport/input/tslib/*.cpp",*/
        ]
    }

    Group {
        //condition: QtHost.config.cursor ### QT_NO_CURSOR
        name: "cursor.qrc"
        files: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/cursor.qrc"
        fileTags: "qrc"
    }
}
