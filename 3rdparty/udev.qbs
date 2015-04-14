import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: udevProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: udevProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "libudev"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: udevProbe.cflags
        cpp.libraryPaths: QtUtils.libraryPaths(udevProbe.libs)
        cpp.dynamicLibraries: QtUtils.dynamicLibraries(udevProbe.libs)
    }
}
