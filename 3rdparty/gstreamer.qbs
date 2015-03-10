import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Product {
    readonly property bool found: gstreamerProbe.found && gstreamerAppProbe.found
                                  && gstreamerVideoProbe.found && gstreamerAudioProbe.found
                                  && gstreamerPBUtilsProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: gstreamerProbe
        name: "gstreamer-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerAppProbe
        name: "gstreamer-app-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerPluginProbe
        name: "gstreamer-app-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerVideoProbe
        name: "gstreamer-video-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerAudioProbe
        name: "gstreamer-audio-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerPBUtilsProbe
        name: "gstreamer-pbutils-1.0"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: gstreamerProbe.cflags
        cpp.libraryPaths: product.found ? Utils.libraryPaths(
                                  gstreamerProbe.libs.concat(
                                  gstreamerAppProbe.libs).concat(
                                  gstreamerVideoProbe.libs).concat(
                                  gstreamerAudioProbe.libs).concat(
                                  gstreamerPBUtilsProbe.libs)) : []
        cpp.dynamicLibraries: product.found ? Utils.dynamicLibraries(
                                  gstreamerProbe.libs.concat(
                                  gstreamerAppProbe.libs).concat(
                                  gstreamerVideoProbe.libs).concat(
                                  gstreamerAudioProbe.libs).concat(
                                  gstreamerPBUtilsProbe.libs)) : []
    }
}

