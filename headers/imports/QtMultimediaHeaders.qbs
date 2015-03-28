import qbs

Group {
    name: "headers"
    prefix: configure.sourcePath + "/qtmultimedia/src/multimedia/"
    files: [
        "*.h",
        "audio/*.h",
        "camera/*.h",
        "controls/*.h",
        "doc/*.h",
        "gsttools_headers/*.h",
        "playback/*.h",
        "qtmultimediaquicktools_headers/*.h",
        "radio/*.h",
        "recording/*.h",
        "video/*.h",
    ]
}
