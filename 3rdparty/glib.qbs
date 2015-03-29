import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: glibProbe.found
    type: "hpp"
    builtByDefault: false

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: glibProbe
        name: "glib-2.0"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: glibProbe.cflags
        cpp.libraryPaths: QtUtils.libraryPaths(glibProbe.libs)
        cpp.dynamicLibraries: QtUtils.dynamicLibraries(glibProbe.libs)
    }
}
