import qbs

StaticLibrary {
    name: "png"

    Depends { name: "cpp" }
    Depends { name: "zlib" }
    Depends { name: "QtHost.includes" }
    QtHost.includes.modules: [ "core" ]

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
