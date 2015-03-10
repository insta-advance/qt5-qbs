import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: glProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: glProbe
        name: "gl"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: glProbe.found
        cpp.libraryPaths: Utils.libraryPaths(glProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(glProbe.libs)
    }
}
