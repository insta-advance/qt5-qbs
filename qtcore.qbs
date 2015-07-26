import qbs
import qbs.TextFile
import "qbs/imports/QtUtils.js" as QtUtils

QtModule {
    name: "QtCore"
    property path basePath: project.sourceDirectory + "/qtbase/src/corelib/"

    Depends { name: "harfbuzz" }
    Depends { name: "pcre" }
    Depends { name: "zlib" }
    Depends { name: "glib"; condition: project.glib }
    Depends { name: "forkfd"; condition: qbs.targetOS.contains("unix") }
    Depends { name: "QtCoreHeaders" }

    cpp.defines: {
        var defines = ["QT_BUILD_CORE_LIB"];
        if (project.icu)
            defines.push("QT_USE_ICU");
        return defines.concat(base);
    }

    cpp.dynamicLibraries: {
        var dynamicLibraries = base;
        if (qbs.targetOS.contains("unix")) {
            dynamicLibraries.push("pthread");
            dynamicLibraries.push("dl");
        }
        if (qbs.targetOS.contains("windows")) {
            dynamicLibraries.push("shell32");
            dynamicLibraries.push("user32");
            if (qbs.targetOS.contains("winrt")) {
                dynamicLibraries.push("runtimeobject");
            } else {
                dynamicLibraries.push("advapi32");
                dynamicLibraries.push("ws2_32");
                dynamicLibraries.push("mpr");
                dynamicLibraries.push("uuid");
                dynamicLibraries.push("ole32");
            }
        }
        if (project.icu) {
            dynamicLibraries.push("icui18n");
            dynamicLibraries.push("icuuc");
            dynamicLibraries.push("icudata");
        }
        return dynamicLibraries;
    }

    cpp.includePaths: [
        project.configDirectory + "/src/corelib/global", // for qconfig.cpp
    ].concat(base)

    QtCoreHeaders {
        name: "headers"
        excludeFiles: {
            var excludeFiles = [basePath + "doc/**", basePath + "kernel/qobjectdefs.h"];
            if (!qbs.targetOS.contains("blackberry")) {
                excludeFiles.push(basePath + "kernel/qeventdispatcher_blackberry_p.h");
                excludeFiles.push(basePath + "kernel/qppsobject_p.h");
                excludeFiles.push(basePath + "tools/qlocale_blackberry.h");
            }
            if (!qbs.targetOS.contains("osx")) {
                excludeFiles.push(basePath + "io/qfilesystemwatcher_fsevents_p.h");
            }
            if (!qbs.targetOS.contains("unix")) {
                excludeFiles.push(basePath + "io/qfilesystemwatcher_inotify_p.h"),
                excludeFiles.push(basePath + "kernel/qeventdispatcher_unix_p.h");
            }
            if (!qbs.targetOS.contains("windows") || qbs.targetOS.contains("winrt")) {
                excludeFiles.push(basePath + "io/qwindowspipereader_p.h");
                excludeFiles.push(basePath + "io/qwindowspipewriter_p.h");
                excludeFiles.push(basePath + "io/qfilesystemwatcher_win_p.h");
                excludeFiles.push(basePath + "io/qwinoverlappedionotifier_p.h");
                excludeFiles.push(basePath + "kernel/qwineventnotifier.h");
                excludeFiles.push(basePath + "kernel/qeventdispatcher_win_p.h");
            }
            if (qbs.targetOS.contains("winrt")) {
                excludeFiles.push(basePath + "io/qfilesystemwatcher*.h");
            }
            if (!qbs.targetOS.contains("winrt")) {
                excludeFiles.push(basePath + "kernel/qeventdispatcher_winrt_p.h");
            }
            if (!project.glib) {
                excludeFiles.push(basePath + "kernel/qeventdispatcher_glib_p.h");
            }
            if (!project.kqueue) {
                excludeFiles.push(basePath + "io/qfilesystemwatcher_kqueue_p.h");
            }
            return excludeFiles;
        }
    }

    Group {
        name: "qconfig"
        files: project.configDirectory + "/src/corelib/global/qconfig.cpp"
        fileTags: "" // don't actually compile this; just make sure we have it
    }

    Group {
        name: "sources"
        prefix: product.basePath
        files: [
            "animation/qabstractanimation.cpp",
            "animation/qanimationgroup.cpp",
            "animation/qparallelanimationgroup.cpp",
            "animation/qpauseanimation.cpp",
            "animation/qpropertyanimation.cpp",
            "animation/qsequentialanimationgroup.cpp",
            "animation/qvariantanimation.cpp",
            "codecs/qbig5codec.cpp",
            "codecs/qeucjpcodec.cpp",
            "codecs/qeuckrcodec.cpp",
            "codecs/qgb18030codec.cpp",
            "codecs/qisciicodec.cpp",
            "codecs/qjiscodec.cpp",
            "codecs/qjpunicode.cpp",
            "codecs/qlatincodec.cpp",
            "codecs/qsimplecodec.cpp",
            "codecs/qsjiscodec.cpp",
            "codecs/qtextcodec.cpp",
            "codecs/qtsciicodec.cpp",
            "codecs/qutfcodec.cpp",
            "global/archdetect.cpp",
            "global/qglobal.cpp",
            "global/qglobalstatic.cpp",
            "global/qhooks.cpp",
            "global/qlibraryinfo.cpp",
            "global/qlogging.cpp",
            "global/qmalloc.cpp",
            "global/qnumeric.cpp",
            "io/qabstractfileengine.cpp",
            "io/qbuffer.cpp",
            "io/qdatastream.cpp",
            "io/qdataurl.cpp",
            "io/qdebug.cpp",
            "io/qdir.cpp",
            "io/qdiriterator.cpp",
            "io/qfile.cpp",
            "io/qfiledevice.cpp",
            "io/qfileinfo.cpp",
            "io/qfileselector.cpp",
            "io/qfilesystemengine.cpp",
            "io/qfilesystementry.cpp",
            "io/qfilesystemwatcher.cpp",
            "io/qfilesystemwatcher_polling.cpp",
            "io/qfsfileengine.cpp",
            "io/qfsfileengine_iterator.cpp",
            "io/qiodevice.cpp",
            "io/qipaddress.cpp",
            "io/qlockfile.cpp",
            "io/qloggingcategory.cpp",
            "io/qloggingregistry.cpp",
            "io/qnoncontiguousbytedevice.cpp",
            "io/qprocess.cpp",
            "io/qresource.cpp",
            "io/qresource_iterator.cpp",
            "io/qsavefile.cpp",
            "io/qsettings.cpp",
            "io/qstandardpaths.cpp",
            "io/qstorageinfo.cpp",
            "io/qtemporarydir.cpp",
            "io/qtemporaryfile.cpp",
            "io/qtextstream.cpp",
            "io/qtldurl.cpp",
            "io/qurl.cpp",
            "io/qurlidna.cpp",
            "io/qurlquery.cpp",
            "io/qurlrecode.cpp",
            "itemmodels/qabstractitemmodel.cpp",
            "itemmodels/qabstractproxymodel.cpp",
            "itemmodels/qidentityproxymodel.cpp",
            "itemmodels/qitemselectionmodel.cpp",
            "itemmodels/qsortfilterproxymodel.cpp",
            "itemmodels/qstringlistmodel.cpp",
            "json/qjsonarray.cpp",
            "json/qjson.cpp",
            "json/qjsondocument.cpp",
            "json/qjsonobject.cpp",
            "json/qjsonparser.cpp",
            "json/qjsonvalue.cpp",
            "json/qjsonwriter.cpp",
            "kernel/qabstracteventdispatcher.cpp",
            "kernel/qabstractnativeeventfilter.cpp",
            "kernel/qbasictimer.cpp",
            "kernel/qcoreapplication.cpp",
            "kernel/qcoreevent.cpp",
            "kernel/qcoreglobaldata.cpp",
            "kernel/qeventloop.cpp",
            "kernel/qmath.cpp",
            "kernel/qmetaobjectbuilder.cpp",
            "kernel/qmetaobject.cpp",
            "kernel/qmetatype.cpp",
            "kernel/qmimedata.cpp",
            "kernel/qobjectcleanuphandler.cpp",
            "kernel/qobject.cpp",
            "kernel/qpointer.cpp",
            "kernel/qsharedmemory.cpp",
            "kernel/qsignalmapper.cpp",
            "kernel/qsocketnotifier.cpp",
            "kernel/qsystemerror.cpp",
            "kernel/qsystemsemaphore.cpp",
            "kernel/qtimer.cpp",
            "kernel/qtranslator.cpp",
            "kernel/qvariant.cpp",
            "mimetypes/mimetypes.qrc",
            "mimetypes/qmimedatabase.cpp",
            "mimetypes/qmimeglobpattern.cpp",
            "mimetypes/qmimemagicrule.cpp",
            "mimetypes/qmimemagicrulematcher.cpp",
            "mimetypes/qmimeprovider.cpp",
            "mimetypes/qmimetype.cpp",
            "mimetypes/qmimetypeparser.cpp",
            "plugin/qelfparser_p.cpp",
            "plugin/qfactoryinterface.cpp",
            "plugin/qfactoryloader.cpp",
            "plugin/qlibrary.cpp",
            "plugin/qmachparser.cpp",
            "plugin/qpluginloader.cpp",
            "plugin/quuid.cpp",
            "statemachine/qabstractstate.cpp",
            "statemachine/qabstracttransition.cpp",
            "statemachine/qeventtransition.cpp",
            "statemachine/qfinalstate.cpp",
            "statemachine/qhistorystate.cpp",
            "statemachine/qsignaltransition.cpp",
            "statemachine/qstate.cpp",
            "statemachine/qstatemachine.cpp",
            "thread/qatomic.cpp",
            "thread/qexception.cpp",
            "thread/qfutureinterface.cpp",
            "thread/qfuturewatcher.cpp",
            "thread/qmutex.cpp",
            "thread/qmutexpool.cpp",
            "thread/qreadwritelock.cpp",
            "thread/qresultstore.cpp",
            "thread/qrunnable.cpp",
            "thread/qsemaphore.cpp",
            "thread/qthread.cpp",
            "thread/qthreadpool.cpp",
            "thread/qthreadstorage.cpp",
            "tools/qarraydata.cpp",
            "tools/qbitarray.cpp",
            "tools/qbytearray.cpp",
            "tools/qbytearraylist.cpp",
            "tools/qbytearraymatcher.cpp",
            "tools/qcollator.cpp",
            "tools/qcommandlineoption.cpp",
            "tools/qcommandlineparser.cpp",
            "tools/qcontiguouscache.cpp",
            "tools/qcryptographichash.cpp",
            "tools/qdatetime.cpp",
            "tools/qdatetimeparser.cpp",
            "tools/qeasingcurve.cpp",
            "tools/qelapsedtimer.cpp",
            "tools/qfreelist.cpp",
            "tools/qharfbuzz.cpp",
            "tools/qhash.cpp",
            "tools/qline.cpp",
            "tools/qlinkedlist.cpp",
            "tools/qlist.cpp",
            "tools/qlocale.cpp",
            "tools/qlocale_tools.cpp",
            "tools/qmap.cpp",
            "tools/qmargins.cpp",
            "tools/qmessageauthenticationcode.cpp",
            "tools/qpoint.cpp",
            "tools/qqueue.cpp",
            "tools/qrect.cpp",
            "tools/qrefcount.cpp",
            "tools/qregexp.cpp",
            "tools/qregularexpression.cpp",
            "tools/qringbuffer.cpp",
            "tools/qscopedpointer.cpp",
            "tools/qscopedvaluerollback.cpp",
            "tools/qshareddata.cpp",
            "tools/qsharedpointer.cpp",
            "tools/qsimd.cpp",
            "tools/qsize.cpp",
            "tools/qstack.cpp",
            "tools/qstringbuilder.cpp",
            "tools/qstring_compat.cpp",
            "tools/qstring.cpp",
            "tools/qstringlist.cpp",
            "tools/qtextboundaryfinder.cpp",
            "tools/qtimeline.cpp",
            "tools/qtimezone.cpp",
            "tools/qtimezoneprivate.cpp",
            "tools/qunicodetools.cpp",
            "tools/qvector.cpp",
            "tools/qversionnumber.cpp",
            "tools/qvsnprintf.cpp",
            "xml/qxmlstream.cpp",
            "xml/qxmlutils.cpp",
        ]
    }

    Group {
        name: "sources_android"
        condition: qbs.targetOS.contains("android")
        prefix: basePath
        files: [
            "io/qstandardpaths_android.cpp",
            "kernel/qjni.cpp",
            "kernel/qjnihelpers.cpp",
            "kernel/qjnionload.cpp",
            "kernel/qsharedmemory_android.cpp",
            "kernel/qsystemsemaphore_android.cpp",
            "tools/qtimezoneprivate_android.cpp",
        ]
    }

    Group {
        name: "sources_darwin"
        condition: qbs.targetOS.contains("darwin")
        prefix: basePath
        files: [
            "io/qsettings_mac.cpp",
            "io/qstorageinfo_mac.cpp",
            "io/qfilesystemwatcher_fsevents_p.h",
            "kernel/qcoreapplication_mac.cpp",
            "kernel/qcore_mac.cpp",
            "tools/qcollator_macx.cpp",
            "tools/qelapsedtimer_mac.cpp",
        ]
    }

    Group {
        name: "sources_haiku"
        condition: qbs.targetOS.contains("haiku")
        prefix: basePath
        files: [
            "io/qstandardpaths_haiku.cpp",
        ]
    }

    Group {
        name: "sources_nacl"
        condition: qbs.targetOS.contains("nacl")
        prefix: basePath
        files: [
            "kernel/qfunctions_nacl.cpp",
        ]
    }

    Group {
        name: "sources_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: basePath
        files: [
            "io/forkfd_qt.cpp",
            "io/qfilesystemengine_unix.cpp",
            "io/qfilesystemiterator_unix.cpp",
            "io/qfilesystemwatcher_inotify.cpp",
            "io/qfsfileengine_unix.cpp",
            "io/qlockfile_unix.cpp",
            "io/qprocess_unix.cpp",
            "io/qstandardpaths_unix.cpp",
            "io/qstorageinfo_unix.cpp",
            "kernel/qcore_unix.cpp",
            "kernel/qcrashhandler.cpp",
            "kernel/qeventdispatcher_unix.cpp",
            "kernel/qsharedmemory_posix.cpp",
            "kernel/qsharedmemory_systemv.cpp",
            "kernel/qsharedmemory_unix.cpp",
            "kernel/qsystemsemaphore_posix.cpp",
            "kernel/qsystemsemaphore_systemv.cpp",
            "kernel/qsystemsemaphore_unix.cpp",
            "kernel/qtimerinfo_unix.cpp",
            "plugin/qlibrary_unix.cpp",
            "thread/qthread_unix.cpp",
            "thread/qwaitcondition_unix.cpp",
            "tools/qelapsedtimer_unix.cpp",
            //"tools/qcollator_posix.cpp",
            "tools/qlocale_unix.cpp",
            "tools/qtimezoneprivate_tz.cpp",
        ]
    }

    Group {
        name: "sources_wince"
        condition: qbs.targetOS.contains("wince")
        prefix: product.basePath
        files: [
            "io/qprocess_wince.cpp",
            "kernel/qfunctions_wince.cpp",
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: product.basePath
        files: [
            "codecs/qwindowscodec.cpp",
            "io/qfilesystemengine_win.cpp",
            "io/qfilesystemiterator_win.cpp",
            "io/qfilesystemwatcher_win.cpp",
            "io/qfsfileengine_win.cpp",
            "io/qlockfile_win.cpp",
            "io/qprocess_win.cpp",
            "io/qsettings_win.cpp",
            "io/qstandardpaths_win.cpp",
            "io/qstorageinfo_win.cpp",
            "io/qwindowspipereader.cpp",
            "io/qwindowspipewriter.cpp",
            "io/qwinoverlappedionotifier.cpp",
            "kernel/qcoreapplication_win.cpp",
            "kernel/qeventdispatcher_win.cpp",
            "kernel/qsharedmemory_win.cpp",
            "kernel/qsystemsemaphore_win.cpp",
            "kernel/qwineventnotifier.cpp",
            "plugin/qlibrary_win.cpp",
            "plugin/qsystemlibrary.cpp",
            "thread/qwaitcondition_win.cpp",
            "thread/qthread_win.cpp",
            "tools/qlocale_win.cpp",
            "tools/qcollator_win.cpp",
            "tools/qelapsedtimer_win.cpp",
            "tools/qtimezoneprivate_win.cpp",
            "tools/qvector_msvc.cpp",
        ]
    }

    Group {
        name: "sources_winrt"
        condition: qbs.targetOS.contains("winrt")
        prefix: product.basePath
        files: [
            "io/qsettings_winrt.cpp",
            "io/qstandardpaths_winrt.cpp",
            "io/qstorageinfo_stub.cpp",
            "kernel/qeventdispatcher_winrt.cpp",
            "kernel/qfunctions_winrt.cpp",
            "thread/qthread_winrt.cpp",
        ]
        excludeFiles: [ // ### fixme: make a windows!winrt group
            "io/qfilesystemwatcher*.cpp",
            "io/qprocess_win.cpp",
            "io/qsettings_win.cpp",
            "io/qstandardpaths_win.cpp",
            "io/qstorageinfo_win.cpp",
            "io/qwinoverlappedionotifier.cpp",
            "io/qwindowspipe*.cpp",
            "kernel/qeventdispatcher_win.cpp",
            "thread/qthread_win.cpp",
            "tools/qtimezoneprivate_win.cpp",
        ]
    }

    Group {
        name: "sources_vxworks"
        condition: qbs.targetOS.contains("vxworks")
        prefix: product.basePath
        files: [
            "kernel/qfunctions_vxworks.cpp",
        ]
    }

    Group {
        name: "sources_glib"
        condition: project.glib
        prefix: product.basePath
        files: [
            "kernel/qeventdispatcher_glib.cpp",
        ]
    }

    Group {
        name: "sources_iconv"
        condition: project.iconv
        prefix: product.basePath
        files: [
            "codecs/qiconvcodec.cpp",
        ]
    }

    Group {
        name: "sources_icu"
        condition: project.icu
        prefix: product.basePath
        files: [
            "codecs/qicucodec.cpp",
            "tools/qcollator_icu.cpp",
            "tools/qlocale_icu.cpp",
            "tools/qtimezoneprivate_icu.cpp",
        ]
    }

    // ### fixme: copying entire directory is no longer supported
    /*Group {
        name: "mkspecs"
        files: project.sourceDirectory + "/qtbase/mkspecs"
        fileTags: "mkspecs"
    }

    Group {
        fileTagsFilter: "mkspecs"
        qbs.install: true
        qbs.installDir: "mkspecs"
    }*/
}
