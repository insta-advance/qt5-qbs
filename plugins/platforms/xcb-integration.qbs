import qbs

QtModule {
    name: "QtXcbQpa"
    condition: project.xcb

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/plugins/platforms/xcb"

    Depends { name: "egl" }
    Depends { name: "freetype2" }
    Depends { name: "qt-xcb" }
    Depends { name: "xkbcommon" }
    Depends { name: "glib"; condition: project.glib }
    Depends { name: "gl"; condition: project.opengl }
    Depends { name: "libudev"; condition: project.libudev }
    Depends { name: "ice"; condition: project.xcb_sm }
    Depends { name: "sm"; condition: project.xcb_sm }
    Depends { name: "xcb-image" }
    Depends { name: "xcb-xfixes" }
    Depends { name: "xcb-randr" }
    Depends { name: "xcb-sync" }
    Depends { name: "xcb-keysyms" }
    Depends { name: "xcb-icccm" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtCore" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtGui" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }
    Depends { name: "QtDBusHeaders"; condition: project.dbus }

    cpp.defines: [
        "QT_BUILD_XCB_DEVICE_LIB",
        "MESA_EGL_NO_X11_HEADERS",
        "QT_NO_DBUS", // ### fixme
        "QT_NO_ACCESSIBILITY_ATSPI_BRIDGE", // ### fixme
    ].concat(base)

    cpp.dynamicLibraries: [
        "pthread",
        "dl",
    ].concat(base)


    cpp.includePaths: [
        basePath,
        basePath + "/gl_integrations",
        project.sourceDirectory + "/qtbase/src/3rdparty/freetype/include", // ### use Probe for system freetype
    ].concat(base)

    Group {
        name: "headers"
        prefix: basePath + "/"
        files: {
            var files = [
                "*.h",
                "gl_integrations/*.h",
                "../../../platformsupport/eventdispatchers/qgenericunixeventdispatcher_p.h",
                "../../../platformsupport/eventdispatchers/qunixeventdispatcher_qpa_p.h",
                "../../../platformsupport/themes/genericunix/qgenericunixthemes_p.h",
                "../../../platformsupport/services/genericunix/qgenericunixservices.cpp",
            ]
            if (project.glib) {
                files.push("../../../platformsupport/eventdispatchers/qeventdispatcher_glib_p.h");
            }
            return files;
        }
        excludeFiles: {
            var excludeFiles = [];
            if (!project.xcb_sm)
                excludeFiles.push("qxcbsessionmanager.h");
            return excludeFiles;
        }
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: {
            var files = [
                "*.cpp",
                "gl_integrations/*.cpp",
                "../../../platformsupport/eventdispatchers/qgenericunixeventdispatcher.cpp",
                "../../../platformsupport/eventdispatchers/qunixeventdispatcher.cpp",
                "../../../platformsupport/themes/genericunix/qgenericunixthemes.cpp",
                "../../../platformsupport/fontdatabases/basic/qbasicfontdatabase.cpp",
            ];
            if (project.glib) {
                files.push("../../../platformsupport/eventdispatchers/qeventdispatcher_glib.cpp");
            }
            return files;
        }
        excludeFiles: {
            var excludeFiles = [];
            if (!project.xcb_sm)
                excludeFiles.push("qxcbsessionmanager.cpp");
            return excludeFiles;
        }
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: product.basePath + "/gl_integrations"
        cpp.defines: product.defines
    }
}
