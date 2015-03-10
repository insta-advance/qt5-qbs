import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: glibProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: glibProbe
        name: "glib-2.0"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: glibProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(glibProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(glibProbe.libs)
    }
}
