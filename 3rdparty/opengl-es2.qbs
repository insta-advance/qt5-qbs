import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: glesv2Probe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: glesv2Probe
        name: "glesv2"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: glesv2Probe.cflags
        cpp.libraryPaths: Utils.libraryPaths(glesv2Probe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(glesv2Probe.libs)
    }
}
