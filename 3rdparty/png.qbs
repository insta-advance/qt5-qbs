import qbs

QtProduct {
    type: "staticlibrary"
    destinationDirectory: project.buildDirectory + "/lib"

    Depends { name: "cpp" }
    Depends { name: "zlib" }

    cpp.includePaths: [
        project.sourcePath + "/include",
        project.sourcePath + "/include/QtCore",
        project.sourcePath + "/qtbase/src/corelib/global",
    ].concat(base)

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/3rdparty/libpng/"
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
