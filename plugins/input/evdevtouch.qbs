import qbs
import qbs.Probes
import "../../qbs/imports/QtUtils.js" as QtUtils

QtPlugin {
    condition: project.evdev
    targetName: "qevdevtouchplugin"
    readonly property string basePath: project.sourceDirectory + "/qtbase/src/plugins/generic/evdevtouch"

    category: "generic"

    cpp.defines: {
        var defines = [];
        if (!project.mtdev)
            defines.push("QT_NO_MTDEV");
        return defines.concat(base);
    }

    Group {
        name: "sources"
        files: [
            product.basePath + "/main.cpp",
            project.sourceDirectory + "/qtbase/src/platformsupport/input/evdevtouch/*.h",
            project.sourceDirectory + "/qtbase/src/platformsupport/input/evdevtouch/*.cpp",
            project.sourceDirectory + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_p.h",
            project.sourceDirectory + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_static_p.h",
            project.sourceDirectory + "/qtbase/src/platformsupport/devicediscovery/qdevicediscovery_static.cpp",
        ]
    }

    Depends { name: "mtdev"; condition: project.mtdev }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtPlatformHeaders" }
    Depends { name: "QtPlatformSupport" }
}
