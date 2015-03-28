import qbs

Project {
    Product {
        name: "bootstrap-headers-core"
        type: "hpp"

        Depends { name: "cpp" }
        Depends { name: "sync" }
        sync.module: "QtCore"

        Group {
            name: "headers (QtCore)"
            fileTags: "header_sync"
            prefix: configure.sourcePath + "/qtbase/src/corelib/"
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
        }
    }

    Product {
        name: "bootstrap-headers-xml"
        type: "hpp"

        Depends { name: "cpp" }
        Depends { name: "sync" }
        sync.module: "QtXml"

        Group {
            name: "headers (QtXml)"
            fileTags: "header_sync"
            prefix: configure.sourcePath + "/qtbase/src/xml/"
            files: [
                "dom/qdom.h",
                "qtxmlglobal.h",
                "sax/qxml.h",
                "sax/qxml_p.h",
            ]
        }
    }
}
