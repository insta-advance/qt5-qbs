import qbs

Project {
    name: "3rdparty"
    references: [
        "angle-egl.qbs",
        "angle-glesv2.qbs",
        "double-conversion.qbs",
        "kms.qbs",
        "egl.qbs",
        "freetype.qbs",
        "glib.qbs",
        "gstreamer.qbs",
        "harfbuzz.qbs",
        "jpeg.qbs",
        "masm.qbs",
        "pcre.qbs",
        "opengl.qbs",
        "png.qbs",
        "udev.qbs",
        "qt-xcb.qbs",
        //"xcb-x11.qbs",
        "xkbcommon.qbs",
        "xkb-x11.qbs",
        "zlib.qbs",
    ]
}
