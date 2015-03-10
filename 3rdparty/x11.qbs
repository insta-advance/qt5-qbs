import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: x11Probe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: x11Probe
        name: "x11-xcb"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: x11Probe.cflags
        cpp.libraryPaths: Utils.libraryPaths(x11Probe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(x11Probe.libs)
    }
}
