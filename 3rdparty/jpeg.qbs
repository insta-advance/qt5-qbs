import qbs

QtProduct {
    type: "staticlibrary"

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cFlags: [
            "-Wno-unused-parameter",
            "-Wno-main",
        ]
    }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtbase/src/3rdparty/libjpeg/"
        files: [
            "cderror.h",
            "cdjpeg.h",
            "ckconfig.c",
            "jaricom.c",
            "jcapimin.c",
            "jcapistd.c",
            "jcarith.c",
            "jccoefct.c",
            "jccolor.c",
            "jcdctmgr.c",
            "jchuff.c",
            "jcinit.c",
            "jcmainct.c",
            "jcmarker.c",
            "jcmaster.c",
            "jcomapi.c",
            "jcparam.c",
            "jcprepct.c",
            "jcsample.c",
            "jctrans.c",
            "jdapimin.c",
            "jdapistd.c",
            "jdarith.c",
            "jdatadst.c",
            "jdatasrc.c",
            "jdcoefct.c",
            "jdcolor.c",
            "jdct.h",
            "jddctmgr.c",
            "jdhuff.c",
            "jdinput.c",
            "jdmainct.c",
            "jdmarker.c",
            "jdmaster.c",
            "jdmerge.c",
            "jdpostct.c",
            "jdsample.c",
            "jdtrans.c",
            "jerror.c",
            "jerror.h",
            "jfdctflt.c",
            "jfdctfst.c",
            "jfdctint.c",
            "jidctflt.c",
            "jidctfst.c",
            "jidctint.c",
            "jinclude.h",
            "jmemmgr.c",
            "jmemnobs.c",
            "jmemsys.h",
            "jmorecfg.h",
            "jpegint.h",
            "jpeglib.h",
            "jquant1.c",
            "jquant2.c",
            "jutils.c",
            "jversion.h",
            "transupp.h",
            "jconfig.h",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: configure.sourcePath + "/qtbase/src/3rdparty/libjpeg"
    }
}
