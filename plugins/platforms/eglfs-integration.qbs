import qbs
import qbs.ModUtils
import qbs.Probes

QtModule {
    condition: project.eglfs
    name: "QtEglDeviceIntegration"

    readonly property string basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/"
    readonly property string platformSupportPath: project.sourceDirectory + "/qtbase/src/platformsupport/"

    cpp.defines: {
        var defines = [
            "QT_BUILD_EGL_DEVICE_LIB",
            "MESA_EGL_NO_X11_HEADERS",
            "QT_NO_EVDEV", // ### build the evdev plugins separately
        ].concat(base);
        if (project.eglfs_viv) {
            defines.push("LINUX");
            defines.push("EGL_API_FB");
        }
        return defines;
    }

    cpp.dynamicLibraries: [
        "pthread",
    ].concat(base)

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/3rdparty/freetype/include", // ### use Probe for system freetype
    ].concat(base)

    Depends { name: "egl" }
    Depends { name: "glib"; condition: project.glib }
    Depends { name: "gl"; condition: project.opengl }
    Depends { name: "libudev"; condition: project.libudev }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }

    Group {
        name: "headers"
        prefix: basePath
        files: [
            "qeglfscontext.h",
            "qeglfsdeviceintegration.h",
            "qeglfshooks.h",
            "qeglfsintegration.h",
            "qeglfsoffscreenwindow.h",
            "qeglfsscreen.h",
            "qeglfswindow.h",
            "qeglfscursor.h",
        ]
    }

    Group {
        name: "headers_platformsupport"
        prefix: platformSupportPath
        files: {
            var files = [
                "eglconvenience/qeglconvenience_p.h",
                "eglconvenience/qeglplatformcontext_p.h",
                "eglconvenience/qeglpbuffer_p.h",
                "eventdispatchers/qunixeventdispatcher_qpa_p.h",
                "fbconvenience/qfbvthandler_p.h",
                "platformcompositor/qopenglcompositorbackingstore_p.h",
                "platformcompositor/qopenglcompositor_p.h",
            ];
            if (project.glib) {
                files.push("eventdispatchers/qeventdispatcher_glib_p.h");
            }
            if (project.libudev) {
                files.push("devicediscovery/qdevicediscovery_p.h");
                files.push("devicediscovery/qdevicediscovery_udev_p.h");
            }
            return files;
        }
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "qeglfscontext.cpp",
            "qeglfsdeviceintegration.cpp",
            "qeglfshooks.cpp",
            "qeglfsintegration.cpp",
            "qeglfsoffscreenwindow.cpp",
            "qeglfsscreen.cpp",
            "qeglfswindow.cpp",
            "qeglfscursor.cpp",
        ]
    }

    Group {
        name: "sources_platformsupport"
        prefix: platformSupportPath
        files: {
            var files = [
                "eglconvenience/qeglconvenience.cpp",
                "eglconvenience/qeglpbuffer.cpp",
                "eglconvenience/qeglplatformcontext.cpp",
                "eventdispatchers/qgenericunixeventdispatcher.cpp",
                "eventdispatchers/qunixeventdispatcher.cpp",
                "fbconvenience/qfbvthandler.cpp",
                "fontdatabases/basic/qbasicfontdatabase.cpp",
                "platformcompositor/qopenglcompositorbackingstore.cpp",
                "platformcompositor/qopenglcompositor.cpp",
                "services/genericunix/qgenericunixservices.cpp",
            ];
            if (project.libudev) {
                files.push("devicediscovery/qdevicediscovery_udev.cpp");
            }
            if (project.glib) {
                files.push("eventdispatchers/qeventdispatcher_glib.cpp");
            }
            return files;
        }
    }

    Group {
        name: "cursor.qrc"
        condition: project.cursor
        files: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/cursor.qrc"
    }
}
