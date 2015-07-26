import qbs

PkgConfigDependency {
    name: "libpng"
    type: project.system_png ? "hpp" : "staticlibrary"
    condition: project.system_png ? base : true

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.system_png ? [
            project.sourceDirectory + "/qtbase/src/3rdparty/libpng",
        ] : base
    }

    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }
    Depends { name: "zlib" }
    Depends { name: "QtCoreHeaders" }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/libpng/"
        files: [
            "pngwutil.c",
            "png.c",
            "png.h",
            "pngconf.h",
            "pngdebug.h",
            "pngerror.c",
            "pngget.c",
            "pnginfo.h",
            "pnglibconf.h",
            "pngmem.c",
            "pngpread.c",
            "pngpriv.h",
            "pngread.c",
            "pngrio.c",
            "pngrtran.c",
            "pngrutil.c",
            "pngset.c",
            "pngstruct.h",
            "pngtrans.c",
            "pngwio.c",
            "pngwrite.c",
            "pngwtran.c",
        ]
    }
}
