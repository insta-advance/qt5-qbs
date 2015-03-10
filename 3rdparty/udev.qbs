import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: udevProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: udevProbe
        name: "libudev"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: udevProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(udevProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(udevProbe.libs)
    }
}
