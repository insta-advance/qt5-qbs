import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: drmProbe.found && gbmProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: drmProbe
        name: "libdrm"
    }

    Probes.PkgConfigProbe {
        id: gbmProbe
        name: "gbm"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: drmProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(drmProbe.libs.concat(gbmProbe.libs))
        cpp.dynamicLibraries: Utils.dynamicLibraries(drmProbe.libs.concat(gbmProbe.libs))
    }
}
