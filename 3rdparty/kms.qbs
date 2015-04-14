import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: drmProbe.found && gbmProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: drmProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "libdrm"
    }

    Probes.PkgConfigProbe {
        id: gbmProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gbm"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: drmProbe.cflags
        cpp.libraryPaths: product.found ? QtUtils.libraryPaths(drmProbe.libs.concat(gbmProbe.libs)) : []
        cpp.dynamicLibraries: product.found ? QtUtils.dynamicLibraries(drmProbe.libs.concat(gbmProbe.libs)) : []
    }
}
