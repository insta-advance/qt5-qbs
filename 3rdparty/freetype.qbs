import qbs

QtProduct {
    type: "staticlibrary"

    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }

    cpp.defines: [
        "FT2_BUILD_LIBRARY",
    ].concat(base)

    cpp.includePaths: [
        configure.sourcePath + "/qtbase/src/3rdparty/freetype/include",
    ].concat(base)

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/freetype/src/"
        files: [
            "base/ftbase.c",
            "base/ftbbox.c",
            "base/ftdebug.c",
            "base/ftglyph.c",
            "base/ftlcdfil.c",
            "base/ftinit.c",
            "base/ftmm.c",
            "base/fttype1.c",
            "base/ftsynth.c",
            "base/ftbitmap.c",
            "bdf/bdf.c",
            "cache/ftcache.c",
            "cff/cff.c",
            "cid/type1cid.c",
            "gzip/ftgzip.c",
            "pcf/pcf.c",
            "pfr/pfr.c",
            "psaux/psaux.c",
            "pshinter/pshinter.c",
            "psnames/psmodule.c",
            "raster/raster.c",
            "sfnt/sfnt.c",
            "smooth/smooth.c",
            "truetype/truetype.c",
            "type1/type1.c",
            "type42/type42.c",
            "winfonts/winfnt.c",
            "lzw/ftlzw.c",
            "otvalid/otvalid.c",
            "autofit/autofit.c",
            //"builds/unix/ftsystem.c", // ### unix
            "base/ftsystem.c",          // ### win32
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            configure.sourcePath + "/qtbase/src/3rdparty/freetype/include",
        ]
    }
}
