import qbs
import qbs.Probes
import qbs.File
import qbs.TextFile
import "3rdparty/egl.qbs" as Egl
import "3rdparty/glib.qbs" as Glib
import "3rdparty/gstreamer.qbs" as Gstreamer
import "3rdparty/kms.qbs" as Kms
import "3rdparty/udev.qbs" as Udev
import "3rdparty/xkb-x11.qbs" as Xkb

Project {
    // Probe products
    Egl { id: egl; name: "eglProbe" }
    Glib { id: glib; name: "glibProbe" }
    Gstreamer { id: gstreamer; name: "gstreamerProbe" }
    Kms { id: kms; name: "kmsProbe" }
    Udev { id: udev; name: "udevProbe" }
    Xkb { id: xkb; name: "xkbProbe" }

    Product {
        name: "autoconfigure"
        type: "autoconfigure"

        readonly property var autoconfig: ({
            egl: egl.found,
            glib: glib.found,
            gstreamer: gstreamer.found,
            kms: kms.found,
            udev: udev.found,
            xkb: xkb.found,
            opengl: glDesktopProbe.found ? "desktop" : (glEs2Probe.found ? "es2" : undefined),
        });

        Probes.PkgConfigProbe {
            id: glEs2Probe
            name: "glesv2"
        }

        Probes.PkgConfigProbe {
            id: glDesktopProbe
            name: "gl"
        }

        Group {
            fileTagsFilter: "json"
            qbs.install: true
        }

        Transformer {
            Artifact {
                filePath: project.buildDirectory + "/qtconfig.json"
                fileTags: "json"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "Saving Qt configuration to " + output.filePath;
                var config = product.autoconfig;
                config.prefix = product.moduleProperty("qbs", "installRoot");
                var targetOS = product.moduleProperty("qbs", "targetOS");
                var toolchain = product.moduleProperty("qbs", "toolchain");
                var architecture = product.moduleProperty("qbs", "architecture");

                // Qt modules
                config.gui = true;
                config.network = true;
                config.widgets = true;
                config.graphicaleffects = true;
                config.multimedia = true;
                config.qml = true;
                config.quick = true;
                config.quickcontrols = true;
                config.svg = true;
                config.qpa = targetOS.contains("linux") ? "xcb" : "windows"; // ### fixme
                config[config.qpa] = true;

                // Compiler/architecture features
                // ### These all need real tests
                config.sse2 = architecture.startsWith("x86");
                config.neon = architecture.startsWith("arm");
                config["c++11"] = true;

                // 3rd-party libraries
                config.pcre = true;
                config.zlib = true;
                config.png = "qt";
                config.jpeg = "qt";
                if (targetOS.contains("windows") && config.opengl != "desktop") {
                    config.angle = true;
                    config.opengl = "es2";
                    config.egl = true;
                }

                // Qt features
                config.accessibility = true;
                config.cursor = true;
                config.freetype = "qt";

                // Qt styles
                config.androidstyle = targetOS.contains("android");
                config.macstyle = targetOS.contains("osx");
                config.windowscestyle = targetOS.contains("windowsce");
                config.windowsmobilestyle = targetOS.contains("windowsce");
                config.windowsvistastyle = targetOS.contains("windows");
                config.windowsxpstyle = targetOS.contains("windows");

                // write out the file
                cmd.config = JSON.stringify(config, null, 4);
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.write(config);
                    file.close();
                }
                return cmd;
            }
        }
    }
}
