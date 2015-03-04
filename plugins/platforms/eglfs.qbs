import qbs
import qbs.Probes

Project {
    readonly property stringList eglDynamicLibraries: {
        var dynamicLibraries = [];

        if (eglProbe.found) {
            for (var i in eglProbe.libs) {
                if (eglProbe.libs[i].startsWith("-l"))
                    dynamicLibraries.push(eglProbe.libs[i].slice(2));
            }
        }

        return dynamicLibraries;
    }
    readonly property stringList kmsDynamicLibraries: {
        var dynamicLibraries = [];

        if (drmProbe.found) {
            for (var i in drmProbe.libs) {
                if (drmProbe.libs[i].startsWith("-l"))
                    dynamicLibraries.push(drmProbe.libs[i].slice(2));
            }
        }

        if (gbmProbe.found) {
            for (var i in gbmProbe.libs) {
                if (gbmProbe.libs[i].startsWith("-l"))
                    dynamicLibraries.push(gbmProbe.libs[i].slice(2));
            }
        }

        return dynamicLibraries;
    }
    readonly property stringList x11DynamicLibraries: {
        var dynamicLibraries = [];

        if (x11Probe.found) {
            for (var i in x11Probe.libs) {
                if (x11Probe.libs[i].startsWith("-l"))
                    dynamicLibraries.push(x11Probe.libs[i].slice(2));
            }
        }

        return dynamicLibraries;
    }
    readonly property stringList libraryPaths: {
        var libraryPaths = [];

        if (eglProbe.found) {
            for (var i in eglProbe.libs) {
                if (eglProbe.libs[i].startsWith("-L"))
                    libraryPaths.push(eglProbe.libs[i].slice(2));
            }
        }

        if (x11Probe.found) {
            for (var i in x11Probe.libs) {
                if (x11Probe.libs[i].startsWith("-L"))
                    libraryPaths.push(x11Probe.libs[i].slice(2));
            }
        }

        if (drmProbe.found) {
            for (var i in drmProbe.libs) {
                if (drmProbe.libs[i].startsWith("-L"))
                    libraryPaths.push(drmProbe.libs[i].slice(2));
            }
        }

        if (gbmProbe.found) {
            for (var i in gbmProbe.libs) {
                if (gbmProbe.libs[i].startsWith("-L"))
                    libraryPaths.push(gbmProbe.libs[i].slice(2));
            }
        }

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

        cpp.dynamicLibraries: [ "EGL", "GLESv2" ]
        cpp.defines: [ "MESA_EGL_NO_X11_HEADERS" ]

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
        condition: eglDynamicLibraries.contains("GAL")
        filePath: "eglfs-imx6.qbs"
        inheritProperties: true
    }

    SubProject {
        condition: drmProbe.found && gbmProbe.found
        filePath: "eglfs-kms.qbs"
        inheritProperties: true
    }

    SubProject {
        condition: x11Probe.found
        filePath: "eglfs-x11.qbs"
        inheritProperties: true
    }
}
