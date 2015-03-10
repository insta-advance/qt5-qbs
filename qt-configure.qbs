import qbs
import qbs.TextFile
import "3rdparty/egl.qbs" as Egl
import "3rdparty/glib.qbs" as Glib
import "3rdparty/opengl-desktop.qbs" as OpenGL
import "3rdparty/opengl-es2.qbs" as OpenGLES
import "3rdparty/udev.qbs" as Udev
import "3rdparty/kms.qbs" as Kms
import "3rdparty/x11.qbs" as X11
import "3rdparty/gstreamer.qbs" as Gstreamer

Project {
    Egl { id: egl; name: "egl" }
    Glib { id: glib; name: "glib" }
    OpenGL { id: opengl; name: "opengl" }
    OpenGLES { id: opengles; name: "opengles" }
    Udev { id: udev; name: "udev" }
    Kms { id: kms; name: "kms" }
    X11 { id: x11; name: "x11" }
    Gstreamer { id: gstreamer; name: "gstreamer" }

    Product {
        name: "qtconfig.json"
        type: "json"

        readonly property var config: ({
            /*sse2: true,
            sse3: true,
            ssse3: true,
            sse4_1: true,
            sse4_2: true,
            avx: true,
            avx2: true,*/
            glib: glib.found,
            egl: egl.found,
            opengl: opengl.found ? "desktop" : (opengles.found ? "es2" : undefined),
            udev: udev.found,
            kms: kms.found,
            x11: x11.found,
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
                cmd.config = JSON.stringify(product.config, null, 4);
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
