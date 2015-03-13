import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: xkbProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: xkbProbe
        name: "xkb-x11"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: xkbProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(xkbProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(xkbProbe.libs)
    }
}
