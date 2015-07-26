import qbs
import qbs.Probes
import "QtUtils.js" as QtUtils

Product {
    type: "hpp"
    profiles: project.targetProfiles
    builtByDefault: false
    condition: probe.found
    readonly property bool found: probe.found

    // to make accessible to sublcasses
    readonly property stringList includePaths: QtUtils.includePaths(probe.cflags)
    readonly property stringList libraryPaths: QtUtils.libraryPaths(probe.libs)
    readonly property stringList dynamicLibraries: QtUtils.dynamicLibraries(probe.libs)

    Depends { name: "cpp" }

    Probes.PkgConfigProbe {
        id: probe
        executable: cpp.toolchainInstallPath + "/pkg-config"
        name: product.name + (product.version ? ("-" + product.version) : "")
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: product.includePaths
        cpp.libraryPaths: product.libraryPaths
        cpp.dynamicLibraries: product.dynamicLibraries
    }
}
