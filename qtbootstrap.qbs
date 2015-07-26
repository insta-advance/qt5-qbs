import qbs
import qbs.File
import qbs.FileInfo

StaticLibrary {
    name: "QtBootstrap"
    profiles: project.hostProfile

    Depends { name: "cpp" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtXmlHeaders" } // ### to be removed once QtXML dependencies are gone (see below)

    property stringList defines: [
        "QT_BOOTSTRAPPED",
        "QT_BUILD_CONFIGURE",
        "QT_CRYPTOGRAPHICHASH_ONLY_SHA1",
        "QT_LITE_UNICODE",
        "QT_NO_CODECS",
        "QT_NO_COMPRESS",
        "QT_NO_DATASTREAM",
        "QT_NO_DEPRECATED",
        "QT_NO_LIBRARY",
        "QT_NO_QOBJECT",
        "QT_NO_SYSTEMLOCALE",
        "QT_NO_THREAD",
        "QT_NO_TRANSLATION",
        "QT_NO_UNICODETABLES",
        "QT_NO_USING_NAMESPACE",
        "QT_NO_CAST_FROM_ASCII",
        "QT_NO_CAST_TO_ASCII",
        "QT_USE_QSTRINGBUILDER",
    ]

    property stringList includePaths: [
        project.sourceDirectory + "/qtbase/mkspecs/" + project.hostMkspec,
    ].concat(base)

    cpp.includePaths: [
    ].concat(includePaths)

    cpp.defines: [
        "QT_BUILD_BOOTSTRAP_LIB",
    ].concat(defines)

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "user32",
            "ole32",
            "advapi32",
            "shell32",
        ]
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/corelib/"
        files: [
            "codecs/qlatincodec.cpp",
            "codecs/qtextcodec.cpp",
            "codecs/qutfcodec.cpp",
            "global/qglobal.cpp",
            "global/qlogging.cpp",
            "global/qmalloc.cpp",
            "global/qnumeric.cpp",
            "io/qabstractfileengine.cpp",
            "io/qbuffer.cpp",
            "io/qdatastream.cpp",
            "io/qdebug.cpp",
            "io/qdir.cpp",
            "io/qdiriterator.cpp",
            "io/qfile.cpp",
            "io/qfiledevice.cpp",
            "io/qfileinfo.cpp",
            "io/qfilesystemengine.cpp",
            "io/qfilesystementry.cpp",
            "io/qfsfileengine.cpp",
            "io/qfsfileengine_iterator.cpp",
            "io/qiodevice.cpp",
            "io/qloggingcategory.cpp",
            "io/qloggingregistry.cpp",
            "io/qstandardpaths.cpp",
            "io/qtemporaryfile.cpp",
            "io/qtextstream.cpp",
            "json/qjsonarray.cpp",
            "json/qjson.cpp",
            "json/qjsondocument.cpp",
            "json/qjsonobject.cpp",
            "json/qjsonparser.cpp",
            "json/qjsonvalue.cpp",
            "json/qjsonwriter.cpp",
            "kernel/qcoreapplication.cpp",
            "kernel/qcoreglobaldata.cpp",
            "kernel/qmetatype.cpp",
            "kernel/qsystemerror.cpp",
            "kernel/qvariant.cpp",
            "plugin/quuid.cpp",
            "tools/qarraydata.cpp",
            "tools/qbitarray.cpp",
            "tools/qbytearray.cpp",
            "tools/qbytearraymatcher.cpp",
            "tools/qcommandlineoption.cpp",
            "tools/qcommandlineparser.cpp",
            "tools/qcryptographichash.cpp",
            "tools/qdatetime.cpp",
            "tools/qhash.cpp",
            "tools/qline.cpp",
            "tools/qlinkedlist.cpp",
            "tools/qlist.cpp",
            "tools/qlocale.cpp",
            "tools/qlocale_tools.cpp",
            "tools/qmap.cpp",
            "tools/qpoint.cpp",
            "tools/qrect.cpp",
            "tools/qregexp.cpp",
            "tools/qringbuffer.cpp",
            "tools/qsize.cpp",
            "tools/qstring_compat.cpp",
            "tools/qstring.cpp",
            "tools/qstringlist.cpp",
            "tools/qvector.cpp",
            "tools/qvsnprintf.cpp",
            "xml/qxmlstream.cpp",
            "xml/qxmlutils.cpp",
            "../xml/sax/qxml.cpp", // ### to be removed once linguist is migrated to qxmlstream
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: project.sourceDirectory + "/qtbase/src/corelib/"
        files: [
            "io/qfilesystemengine_win.cpp",
            "io/qfilesystemiterator_win.cpp",
            "io/qfsfileengine_win.cpp",
            "io/qstandardpaths_win.cpp",
            "kernel/qcoreapplication_win.cpp",
            "plugin/qsystemlibrary.cpp",
        ]
    }

    Group {
        name: "sources_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: project.sourceDirectory + "/qtbase/src/corelib/"
        files: [
            "io/qfilesystemengine_unix.cpp",
            "io/qfilesystemiterator_unix.cpp",
            "io/qfsfileengine_unix.cpp",
            "io/qstandardpaths_unix.cpp",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.defines: product.defines
        cpp.includePaths: product.cpp.includePaths
    }
}
