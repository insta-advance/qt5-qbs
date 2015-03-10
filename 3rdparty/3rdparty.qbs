import qbs

Project {
    name: "3rdparty"
    references: [
        "double-conversion.qbs",
        "kms.qbs",
        "egl.qbs",
        "freetype.qbs",
        "glib.qbs",
        "gstreamer.qbs",
        "harfbuzz.qbs",
        "jpeg.qbs",
        "masm.qbs",
        //"pcre.qbs",
        "opengl-desktop.qbs",
        "opengl-es2.qbs",
        "png.qbs",
        "udev.qbs",
        "x11.qbs",
        "zlib.qbs",
    ]
}
