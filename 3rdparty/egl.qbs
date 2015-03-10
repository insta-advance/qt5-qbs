import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: eglProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: eglProbe
        name: "egl"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: eglProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(eglProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(eglProbe.libs)
    }
}
