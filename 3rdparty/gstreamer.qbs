import qbs
import qbs.Probes
import "../qbs/imports/QtUtils.js" as QtUtils

Product {
    readonly property bool found: gstreamerProbe.found && gstreamerAppProbe.found
                                  && gstreamerVideoProbe.found && gstreamerAudioProbe.found
                                  && gstreamerPBUtilsProbe.found
    type: "hpp"

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: gstreamerProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerAppProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-app-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerPluginProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-app-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerVideoProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-video-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerAudioProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-audio-1.0"
    }

    Probes.PkgConfigProbe {
        id: gstreamerPBUtilsProbe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: "gstreamer-pbutils-1.0"
    }

    Export {
        Depends { name: "cpp" }
        cpp.cxxFlags: gstreamerProbe.cflags
        cpp.libraryPaths: product.found ? QtUtils.libraryPaths(
                                  gstreamerProbe.libs.concat(
                                  gstreamerAppProbe.libs).concat(
                                  gstreamerVideoProbe.libs).concat(
                                  gstreamerAudioProbe.libs).concat(
                                  gstreamerPBUtilsProbe.libs)) : []
        cpp.dynamicLibraries: product.found ? QtUtils.dynamicLibraries(
                                  gstreamerProbe.libs.concat(
                                  gstreamerAppProbe.libs).concat(
                                  gstreamerVideoProbe.libs).concat(
                                  gstreamerAudioProbe.libs).concat(
                                  gstreamerPBUtilsProbe.libs)) : []
    }
}

