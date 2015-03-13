import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: xcbProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: xcbProbe
        name: "x11-xcb"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: xcbProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(xcbProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(xcbProbe.libs)
    }
}
