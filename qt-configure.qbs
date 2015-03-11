import qbs
import qbs.TextFile
import "3rdparty/egl.qbs" as Egl
import "3rdparty/glib.qbs" as Glib
import "3rdparty/opengl-desktop.qbs" as OpenGL
import "3rdparty/opengl-es2.qbs" as OpenGLES
import "3rdparty/udev.qbs" as Udev
import "3rdparty/kms.qbs" as Kms
import "3rdparty/xcb.qbs" as Xcb
import "3rdparty/gstreamer.qbs" as Gstreamer

Project {
    Egl { id: egl; name: "egl" }
    Glib { id: glib; name: "glib" }
    OpenGL { id: opengl; name: "opengl" }
    OpenGLES { id: opengles; name: "opengles" }
    Udev { id: udev; name: "udev" }
    Kms { id: kms; name: "kms" }
    Xcb { id: xcb; name: "xcb" }
    Gstreamer { id: gstreamer; name: "gstreamer" }

    Product {
        name: "qtconfig-" + project.profile + ".json"
        type: "json"

        readonly property var config: ({
            // ### perform better checks for these
            sse2: qbs.architecture != "arm",
            sse3: qbs.architecture != "arm",
            ssse3: qbs.architecture != "arm",
            sse4_1: qbs.architecture != "arm",
            sse4_2: qbs.architecture != "arm",
            avx: qbs.architecture != "arm",
            avx2: qbs.architecture != "arm",
            neon: qbs.architecture == "arm",
            // ###
            glib: glib.found,
            egl: egl.found,
            opengl: opengl.found ? "desktop" : (opengles.found ? "es2" : false),
            udev: udev.found,
            kms: kms.found,
            xcb: xcb.found,
            gstreamer: gstreamer.found,
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
