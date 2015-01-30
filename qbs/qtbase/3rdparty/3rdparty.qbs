import qbs

Project {
    name: "3rdparty"
    references: [
        "freetype.qbs",
        "harfbuzz.qbs",
        "jpeg.qbs",
        "png.qbs",
        "zlib.qbs",
        "pcre.qbs",
    ]
}
