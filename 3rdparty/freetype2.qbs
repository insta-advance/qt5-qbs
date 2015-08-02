import qbs

PkgConfigDependency {
    name: "freetype2"
    type: project.system_freetype ? "hpp" : "staticlibrary"
    condition: project.system_freetype ? found : true
    destinationDirectory: project.buildDirectory + "/lib"

    readonly property string prefix: project.sourceDirectory + "/qtbase/src/3rdparty/freetype/src/"

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.system_freetype ? product.includePaths : [
            project.sourceDirectory + "/qtbase/src/3rdparty/freetype/include",
        ]
    }

    Depends { name: "Android.ndk"; condition: qbs.targetOS.contains("android") }
    Depends { name: "cpp" }
    Depends { name: "Qt.core-private"; condition: !project.system_freetype }

    cpp.defines: [
        "FT2_BUILD_LIBRARY",
    ].concat(base)

    cpp.includePaths: [
        project.sourceDirectory + "/qtbase/src/3rdparty/freetype/include",
    ].concat(base)

    Group {
        name: "sources"
        prefix: product.prefix
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
        ]
    }

    Group {
        name: "sources_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: product.prefix
        files: [
            "../builds/unix/ftsystem.c",
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: product.prefix
        files: [
            "base/ftsystem.c",
        ]
    }
}
