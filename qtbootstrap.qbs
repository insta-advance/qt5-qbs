import qbs
import qbs.File
import qbs.FileInfo
import "qbs/imports/QtUtils.js" as QtUtils
import "headers/QtXmlHeaders.qbs" as QtXmlHeaders

QtModuleProject {
    id: module
    name: "QtBootstrap"
    simpleName: "bootstrap"
    prefix: project.sourceDirectory + "/qtbase/src/corelib/"
    defines: [
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
    ]
    includePaths: [
        project.sourceDirectory + "/qtbase/mkspecs/" + project.hostMkspec,
    ].concat(QtUtils.includesForModule("QtCore-private", project.buildDirectory + '/' + module.simpleName, project.version))
    .concat(QtUtils.includesForModule("QtXml-private", project.buildDirectory + '/' + module.simpleName, project.version))

    QtHeaders {
        name: module.headersName
        profiles: project.hostProfile
        sync.module: "QtCore"
        sync.prefix: module.simpleName
        sync.classNames: ({
            "qglobal.h": ["QtGlobal"],
            "qendian.h": ["QtEndian"],
            "qconfig.h": ["QtConfig"],
            "qplugin.h": ["QtPlugin"],
            "qalgorithms.h": ["QtAlgorithms"],
            "qcontainerfwd.h": ["QtContainerFwd"],
            "qdebug.h": ["QtDebug"],
            "qnamespace.h": ["Qt"],
            "qnumeric.h": ["QtNumeric"],
            "qvariant.h": ["QVariantHash", "QVariantList", "QVariantMap"],
            "qbytearray.h": ["QByteArrayData"],
            "qbytearraylist.h": ["QByteArrayList"],
        })
        Group {
            name: "headers"
            prefix: module.prefix
            files: [
                "arch/qatomic_bootstrap.h",
                "codecs/qtextcodec.h",
                "codecs/qtextcodec_p.h",
                "codecs/qutfcodec_p.h",
                "global/qcompilerdetection.h",
                "global/qendian.h",
                "global/qflags.h",
                "global/qglobal.h",
                "global/qglobalstatic.h",
                "global/qhooks_p.h",
                "global/qisenum.h",
                "global/qlibraryinfo.h",
                "global/qlogging.h",
                "global/qnamespace.h",
                "global/qnumeric.h",
                "global/qnumeric_p.h",
                "global/qprocessordetection.h",
                "global/qsysinfo.h",
                "global/qsystemdetection.h",
                "global/qtypeinfo.h",
                "global/qtypetraits.h",
                "global/qt_windows.h",
                "io/qabstractfileengine_p.h",
                "io/qbuffer.h",
                "io/qdatastream.h",
                "io/qdebug.h",
                "io/qdebug_p.h",
                "io/qdir.h",
                "io/qdiriterator.h",
                "io/qfiledevice.h",
                "io/qfiledevice_p.h",
                "io/qfile.h",
                "io/qfileinfo.h",
                "io/qfileinfo_p.h",
                "io/qfile_p.h",
                "io/qfilesystemengine_p.h",
                "io/qfilesystementry_p.h",
                "io/qfilesystemiterator_p.h",
                "io/qfilesystemmetadata_p.h",
                "io/qfsfileengine_iterator_p.h",
                "io/qfsfileengine_p.h",
                "io/qiodevice.h",
                "io/qiodevice_p.h",
                "io/qloggingcategory.h",
                "io/qloggingregistry_p.h",
                "io/qprocess.h",
                "io/qprocess_p.h",
                "io/qsettings.h",
                "io/qstandardpaths.h",
                "io/qtemporaryfile.h",
                "io/qtemporaryfile_p.h",
                "io/qtextstream.h",
                "io/qtextstream_p.h",
                "io/qurl.h",
                "json/qjsonarray.h",
                "json/qjsondocument.h",
                "json/qjsonobject.h",
                "json/qjsonvalue.h",
                "kernel/qcoreapplication.h",
                "kernel/qcoreglobaldata_p.h",
                "kernel/qcore_unix_p.h",
                "kernel/qfunctions_p.h",
                "kernel/qmath.h",
                "kernel/qmetaobject.h",
                "kernel/qmetaobject_moc_p.h",
                "kernel/qmetaobject_p.h",
                "kernel/qmetatype.h",
                "kernel/qmetatype_p.h",
                "kernel/qmetatypeswitcher_p.h",
                "kernel/qobjectdefs.h",
                "kernel/qobjectdefs_impl.h",
                "kernel/qobject.h",
                "kernel/qpointer.h",
                "kernel/qsystemerror_p.h",
                "kernel/qtranslator.h",
                "kernel/qtranslator_p.h",
                "kernel/qvariant.h",
                "kernel/qvariant_p.h",
                "plugin/qfactoryloader_p.h",
                "plugin/qlibrary.h",
                "plugin/qlibrary_p.h",
                "plugin/qplugin.h",
                "plugin/qsystemlibrary_p.h",
                "plugin/quuid.h",
                "thread/qatomic.h",
                "thread/qbasicatomic.h",
                "thread/qgenericatomic.h",
                "thread/qmutex.h",
                "thread/qmutexpool_p.h",
                "thread/qorderedmutexlocker_p.h",
                "thread/qreadwritelock.h",
                "thread/qthreadstorage.h",
                "tools/qalgorithms.h",
                "tools/qarraydata.h",
                "tools/qbitarray.h",
                "tools/qbytearray.h",
                "tools/qbytearray_p.h",
                "tools/qbytearraylist.h",
                "tools/qchar.h",
                "tools/qcommandlineoption.h",
                "tools/qcommandlineparser.h",
                "tools/qcontainerfwd.h",
                "tools/qcontiguouscache.h",
                "tools/qcryptographichash.h",
                "tools/qdatetime.h",
                "tools/qdatetimeparser_p.h",
                "tools/qdatetime_p.h",
                "tools/qeasingcurve.h",
                "tools/qelapsedtimer.h",
                "tools/qhash.h",
                "tools/qhashfunctions.h",
                "tools/qiterator.h",
                "tools/qline.h",
                "tools/qlist.h",
                "tools/qlinkedlist.h",
                "tools/qlocale.h",
                "tools/qlocale_p.h",
                "tools/qlocale_tools_p.h",
                "tools/qmap.h",
                "tools/qmargins.h",
                "tools/qpair.h",
                "tools/qpoint.h",
                "tools/qrect.h",
                "tools/qrefcount.h",
                "tools/qregexp.h",
                "tools/qregularexpression.h",
                "tools/qringbuffer_p.h",
                "tools/qscopedpointer.h",
                "tools/qset.h",
                "tools/qshareddata.h",
                "tools/qsharedpointer.h",
                "tools/qsharedpointer_impl.h",
                "tools/qsimd_p.h",
                "tools/qsize.h",
                "tools/qstack.h",
                "tools/qstringbuilder.h",
                "tools/qstring.h",
                "tools/qstringiterator_p.h",
                "tools/qstringlist.h",
                "tools/qstringmatcher.h",
                "tools/qtimezone.h",
                "tools/qtools_p.h",
                "tools/qvarlengtharray.h",
                "tools/qvector.h",
                "xml/qxmlstream.h",
                "xml/qxmlutils_p.h",
            ]
            fileTags: "header_sync"
        }
    }

    QtHeaders { // ### to be removed once QtXML dependencies are gone (see below)
        name: "QtXmlBootstrapHeaders"
        profiles: project.hostProfile
        sync.module: "QtXml"
        sync.prefix: "bootstrap"
        QtXmlHeaders { fileTags: "header_sync" }
    }

    StaticLibrary {
        name: module.privateName
        targetName: module.targetName
        profiles: project.hostProfile
        destinationDirectory: project.buildDirectory + "/lib"

        Depends { name: module.headersName }
        Depends { name: "QtXmlBootstrapHeaders" }
        Depends { name: "cpp" }

        cpp.includePaths: module.includePaths

        cpp.defines: [
            "QT_BUILD_BOOTSTRAP_LIB",
            "QT_USE_QSTRINGBUILDER",
        ].concat(module.defines)

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
            prefix: module.prefix
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
            cpp.defines: module.defines
            cpp.includePaths: module.includePaths
        }
    }
}
