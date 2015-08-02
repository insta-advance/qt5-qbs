import qbs

PkgConfigDependency {
    name: "libpng"
    type: project.system_png ? "hpp" : "staticlibrary"
    condition: project.system_png ? found : true
    destinationDirectory: project.buildDirectory + "/lib"

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.system_png ? includePaths : [
            project.sourceDirectory + "/qtbase/src/3rdparty/libpng",
        ]
    }

    Depends { name: "Android.ndk"; condition: qbs.targetOS.contains("android") }
    Depends { name: "cpp" }
    Depends { name: "zlib" }
    Depends { name: "Qt.core-private"; condition: !project.system_png }

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
