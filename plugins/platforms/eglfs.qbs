import qbs
import qbs.Probes
import "../../qbs/utils.js" as Utils

Project {
    readonly property stringList eglDynamicLibraries: {
        var libs = [];

        if (eglProbe.found)
            libs = libs.concat(Utils.dynamicLibraries(eglProbe.libs));

        return libs;
    }
    readonly property stringList kmsDynamicLibraries: {
        var libs = [];

        if (drmProbe.found)
            libs = libs.concat(Utils.dynamicLibraries(drmProbe.libs));

        if (gbmProbe.found)
            libs = libs.concat(Utils.dynamicLibraries(gbmProbe.libs));

        return libs;
    }
    readonly property stringList x11DynamicLibraries: {
        var libs = [];

        if (x11Probe.found)
            libs = libs.concat(Utils.dynamicLibraries(x11Probe.libs));

        return libs;
    }
    readonly property stringList libraryPaths: {
        var libraryPaths = [];

        if (eglProbe.found)
            libraryPaths = libraryPaths.concat(Utils.libraryPaths(eglProbe.libs));

        if (x11Probe.found)
            libraryPaths = libraryPaths.concat(Utils.libraryPaths(x11Probe.libs));

        if (drmProbe.found)
            libraryPaths = libraryPaths.concat(Utils.libraryPaths(drmProbe.libs));

        if (gbmProbe.found)
            libraryPaths = libraryPaths.concat(Utils.libraryPaths(gbmProbe.libs));

        return libraryPaths;
    }
    readonly property stringList cxxFlags: {
        var cxxFlags = [];

        if (eglProbe.found)
            Array.prototype.push.apply(cxxFlags, eglProbe.cflags);

        if (x11Probe.found)
            Array.prototype.push.apply(cxxFlags, eglProbe.cflags);

        if (drmProbe.found)
            Array.prototype.push.apply(cxxFlags, eglProbe.cflags);

        if (gbmProbe.found)
            Array.prototype.push.apply(cxxFlags, eglProbe.cflags);

        return cxxFlags;
    }
    readonly property stringList includePaths: [
        project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs",
    ]

    qbsSearchPaths: ["../../qbs", "."]

    references: "eglfs-integration.qbs"

    QtPlugin {
        category: "platforms"
        targetName: "qeglfs"

        includeDependencies: ["QtCore", "QtGui-private", "QtPlatformSupport-private"]

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtEglDeviceIntegration" }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtbase/src/plugins/platforms/eglfs/"
            files: "qeglfsmain.cpp"
            fileTags: "moc"
            overrideTags: false
        }

        Probes.PkgConfigProbe {
            id: eglProbe
            name: "egl"
        }

        Probes.PkgConfigProbe {
            id: x11Probe
            name: "x11-xcb"
        }

        Probes.PkgConfigProbe {
            id: drmProbe
            name: "libdrm"
        }

        Probes.PkgConfigProbe {
            id: gbmProbe
            name: "gbm"
        }
    }

    SubProject {
        filePath: "eglfs-imx6.qbs"
    }

    SubProject {
        Properties { condition: drmProbe.found && gbmProbe.found }
        filePath: "eglfs-kms.qbs"
    }

    SubProject {
        Properties { condition: x11Probe.found }
        filePath: "eglfs-x11.qbs"
    }
}
