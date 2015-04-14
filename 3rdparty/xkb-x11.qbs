import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: xkbProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: xkbProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "xkb-x11"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: xkbProbe.cflags
        cpp.libraryPaths: QtUtils.libraryPaths(xkbProbe.libs)
        cpp.dynamicLibraries: QtUtils.dynamicLibraries(xkbProbe.libs)
    }
}
