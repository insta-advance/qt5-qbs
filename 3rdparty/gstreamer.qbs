import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: gstreamerProbe.found && gstreamerVideoProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: gstreamerProbe
        name: "gstreamer-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerVideoProbe
        name: "gstreamer-video-1.0"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: gstreamerProbe.cflags
        cpp.libraryPaths: Utils.libraryPaths(gstreamerProbe.libs)
        cpp.dynamicLibraries: Utils.dynamicLibraries(gstreamerProbe.libs)
    }
}

