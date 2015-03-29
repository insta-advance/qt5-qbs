import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: eglProbe.found
    type: "hpp"
    builtByDefault: false

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: eglProbe
        name: "egl"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: eglProbe.cflags
        cpp.libraryPaths: QtUtils.libraryPaths(eglProbe.libs)
        cpp.dynamicLibraries: QtUtils.dynamicLibraries(eglProbe.libs)
    }
}
