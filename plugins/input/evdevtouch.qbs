import qbs
import qbs.Probes
import "../../qbs/imports/QtUtils.js" as QtUtils

QtPlugin {
    targetName: "qevdevtouchplugin"
    readonly property string basePath: project.sourcePath + "/qtbase/src/plugins/generic/evdevtouch"

    category: "generic"

    includeDependencies: ["QtCore-private", "QtGui-private", "QtPlatformSupport-private"]

    cpp.defines: {
        var defines = base;
        if (!mtdevProbe.found)
            defines.push("QT_NO_MTDEV");
        return defines;
    }

    cpp.libraryPaths: mtdevProbe.found ? QtUtils.libraryPaths(mtdevProbe.libs).concat(base) : base
    cpp.dynamicLibraries: mtdevProbe.found ? QtUtils.dynamicLibraries(mtdevProbe.libs).concat(base) : base

    Probes.PkgConfigProbe {
        id: mtdevProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "mtdev"
    }

    Group {
        name: "sources"
        files: [
            product.basePath + "/main.cpp",
            project.sourcePath + "/qtbase/src/platformsupport/input/evdevtouch/*.h",
            project.sourcePath + "/qtbase/src/platformsupport/input/evdevtouch/*.cpp",
            project.sourcePath + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_p.h",
            project.sourcePath + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_static_p.h",
            project.sourcePath + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_static.cpp",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
}
