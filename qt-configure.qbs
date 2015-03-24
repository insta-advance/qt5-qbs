import qbs
import qbs.TextFile
import "3rdparty/egl.qbs" as Egl
import "3rdparty/glib.qbs" as Glib
import "3rdparty/gstreamer.qbs" as Gstreamer
import "3rdparty/kms.qbs" as Kms
import "3rdparty/opengl.qbs" as OpenGL
import "3rdparty/udev.qbs" as Udev
import "3rdparty/xcb-x11.qbs" as Xcb
import "3rdparty/xkb-x11.qbs" as Xkb

Project {
    Egl { id: egl; name: "egl" }
    Glib { id: glib; name: "glib" }
    Gstreamer { id: gstreamer; name: "gstreamer" }
    Kms { id: kms; name: "kms" }
    OpenGL { id: opengl; name: "opengl" }
    Udev { id: udev; name: "udev" }
    Xcb { id: xcb; name: "xcb-x11" }
    Xkb { id: xkb; name: "xkb" }

    Product {
        name: "qtconfig-" + project.profile + ".json"
        type: "json"

        readonly property var config: ({
            egl: egl.found,
            glib: glib.found,
            gstreamer: gstreamer.found,
            kms: kms.found,
            opengl: opengl.detectedVersion,
            udev: udev.found,
            xcb: xcb.found,
            xkb: xkb.found,
        })

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
                cmd.description = "generating configuration";
                var config = product.config;
                // All variables coming from here are considered false by default, so only keep the truthy ones
                for (var i in config) {
                    if (!config[i])
                        delete config[i];
                }
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
