import qbs
import qbs.Probes

QtPlugin {
    condition: drmProbe.found && gbmProbe.found
    category: "platforms"

    cpp.defines: [
        "MESA_EGL_NO_X11_HEADERS",
    ]

    cpp.cxxFlags: drmProbe.cflags.concat(gbmProbe.cflags).concat(udevProbe.cflags)
    cpp.dynamicLibraries: {
        var libs = drmProbe.libs.concat(gbmProbe.libs).concat(udevProbe.libs);
        for (var i in libs)
            libs[i] = libs[i].slice(2);
        return libs.concat(["EGL", "GLESv2"]);
    }
    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs",
    ]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtEglDeviceIntegration" }

    Probes.PkgConfigProbe {
        id: drmProbe
        name: "libdrm"
    }

    Probes.PkgConfigProbe {
        id: gbmProbe
        name: "gbm"
    }

    Probes.PkgConfigProbe {
        id: udevProbe
        name: "libudev"
    }

    Group {
        name: "headers"
        prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/deviceintegration/eglfs_kms/"
        files: [
            "qeglfskmscursor.h", // ### QT_NO_CURSOR
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/deviceintegration/eglfs_kms/"
        files: [
            "qeglfskmscursor.cpp", // ### QT_NO_CURSOR
            "qeglfskmsdevice.cpp",
            "qeglfskmsdevice.h",
            "qeglfskmsintegration.cpp",
            "qeglfskmsintegration.h",
            "qeglfskmsmain.cpp",
            "qeglfskmsscreen.cpp",
            "qeglfskmsscreen.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources (platform support)"
        prefix: project.sourceDirectory + "/qtbase/src/platformsupport/"
        files: [
            "devicediscovery/qdevicediscovery_p.h",
            "devicediscovery/qdevicediscovery_udev_p.h",
            "devicediscovery/qdevicediscovery_udev.cpp",
        ]
    }
}
