import qbs

Project {
    name: "3rdparty"
    references: [
        "double-conversion.qbs",
        "freetype.qbs",
        "harfbuzz.qbs",
        "jpeg.qbs",
        "masm.qbs",
        "pcre.qbs",
        "png.qbs",
        "zlib.qbs",
    ]
}