import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: gbmProbe
        name: "gbm"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: gbmProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(gbmProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(gbmProbe.libs)
    }
}
