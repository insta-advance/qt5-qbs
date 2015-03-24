import qbs
import qbs.Probes
import "../qbs/utils.js" as Utils

Project {
    readonly property string detectedVersion: {
        if (glDesktopProbe.found)
            return "desktop";
        if (qbs.targetOS.contains("windows") || glEs2Probe.found)
            return "es2";
        return "";
    }

    Product {
        name: "opengl"
        type: "hpp"
        builtByDefault: false

        Depends { name: "configure" }
        Depends { name: "cpp" }
        Depends { name: "angle-glesv2"; condition: configure.angle }

        Probes.PkgConfigProbe {
            id: glEs2Probe
            name: "glesv2"
        }

        Probes.PkgConfigProbe {
            id: glDesktopProbe
            name: "gl"
        }

        Export {
            Depends { name: "cpp" }
            cpp.cxxFlags: {
                if (configure.opengl == "desktop")
                    return glDesktopProbe.cflags;
                if (configure.opengl == "es2")
                    return glEs2Probe.cflags;
                // angle?
            }
            cpp.libraryPaths: {
                if (configure.opengl == "desktop")
                    return Utils.libraryPaths(glDesktopProbe.libs);
                if (configure.opengl == "es2")
                    return Utils.libraryPaths(glEs2Probe.libs);
                // angle?
            }
            cpp.dynamicLibraries: {
                if (configure.opengl == "desktop")
                    return Utils.dynamicLibraries(glDesktopProbe.libs);
                if (configure.opengl == "es2")
                    return Utils.dynamicLibraries(glEs2Probe.libs);
                // angle?
            }
        }
    }
}
