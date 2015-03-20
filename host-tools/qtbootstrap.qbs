import qbs
import qbs.File
import qbs.FileInfo

QtProduct {
    type: "staticlibrary"
    name: "QtBootstrap"

    property stringList bootstrapDefines: [
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

    property stringList bootstrapIncludes: [
        project.sourcePath + "/qtbase/mkspecs/" + project.host,
    ]

    includeDependencies: ["QtCore", "QtCore-private", "QtXml", "QtXml-private"]

    cpp.defines: base.concat(bootstrapDefines).concat([
        "QT_BUILD_BOOTSTRAP_LIB",
    ])

    cpp.includePaths: base.concat(bootstrapIncludes)

    // ### mingw: cpp.cxxFlags: "-std=gnu++0x"
    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "user32",
            "ole32",
            "advapi32",
            "shell32",
        ]
    }

    Depends { name: "cpp" }
    Depends { name: "bootstrap-headers-core" }
    Depends { name: "bootstrap-headers-xml" }

    Group {
        name: "sources"
        prefix: project.sourcePath + "/qtbase/src/corelib/"
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
            "io/qfileinfo.cpp",
            "io/qfilesystementry.cpp",
            "io/qfilesystemengine.cpp",
            "io/qfsfileengine.cpp",
            "io/qfsfileengine_iterator.cpp",
            "io/qiodevice.cpp",
            "io/qfiledevice.cpp",
            "io/qtemporaryfile.cpp",
            "io/qtextstream.cpp",
            "io/qstandardpaths.cpp",
            "io/qloggingcategory.cpp",
            "io/qloggingregistry.cpp",
            "kernel/qcoreapplication.cpp",
            "kernel/qcoreglobaldata.cpp",
            "kernel/qmetatype.cpp",
            "kernel/qvariant.cpp",
            "kernel/qsystemerror.cpp",
            "plugin/quuid.cpp",
            "tools/qbitarray.cpp",
            "tools/qbytearray.cpp",
            "tools/qarraydata.cpp",
            "tools/qbytearraymatcher.cpp",
            "tools/qcommandlineparser.cpp",
            "tools/qcommandlineoption.cpp",
            "tools/qcryptographichash.cpp",
            "tools/qdatetime.cpp",
            "tools/qhash.cpp",
            "tools/qlist.cpp",
            "tools/qlinkedlist.cpp",
            "tools/qlocale.cpp",
            "tools/qlocale_tools.cpp",
            "tools/qmap.cpp",
            "tools/qregexp.cpp",
            "tools/qpoint.cpp",
            "tools/qrect.cpp",
            "tools/qsize.cpp",
            "tools/qline.cpp",
            "tools/qstring.cpp",
            "tools/qstring_compat.cpp",
            "tools/qstringlist.cpp",
            "tools/qvector.cpp",
            "tools/qvsnprintf.cpp",
            "xml/qxmlutils.cpp",
            "xml/qxmlstream.cpp",
            "json/qjson.cpp",
            "json/qjsondocument.cpp",
            "json/qjsonobject.cpp",
            "json/qjsonarray.cpp",
            "json/qjsonvalue.cpp",
            "json/qjsonparser.cpp",
            "json/qjsonwriter.cpp",
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: project.sourcePath + "/qtbase/src/corelib/"
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
        prefix: project.sourcePath + "/qtbase/src/corelib/"
        files: [
            "io/qfilesystemengine_unix.cpp",
            "io/qfilesystemiterator_unix.cpp",
            "io/qfsfileengine_unix.cpp",
            "io/qstandardpaths_unix.cpp",
        ]
    }

    Group {
        name: "xml_sources"
        prefix: project.sourcePath + "/qtbase/src/xml/"
        files: [
            "dom/qdom.cpp",
            "sax/qxml.cpp",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.defines: bootstrapDefines
        cpp.includePaths: bootstrapIncludes
    }
}
