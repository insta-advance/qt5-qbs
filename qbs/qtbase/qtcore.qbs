import qbs

QtModule {
    name: "QtCore"
    property path basePath: project.sourceDirectory + "/qtbase/src/corelib"

    Depends { name: "harfbuzz" }
    Depends { name: "pcre" }
    Depends { name: "zlib" }
    QtHost.includes.modules: [ "core-private" ]

    cpp.defines: base.concat([
        "QT_BUILD_CORE_LIB",
    ])

    cpp.includePaths: base.concat([
        project.sourceDirectory + "/qtbase/src/3rdparty/forkfd"
    ])

    Properties {
        condition: qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: [
            "pthread",
            "dl",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "shell32",
            "user32",
            "ole32",
            "advapi32",
            "ws2_32",
            "mpr",
        ]
    }

    // Headers to sync but which include the metaobject from the cpp side
    // ### this should be handled in the moc rule, as some cases may need both --
    // better to look at the source and deduce from there (c.f. qtimer.h)
    Group {
        id: headers_moc_p
        name: "_headers_delayed_moc"
        fileTags: ["moc_hpp_p", "header_sync"]
        prefix: basePath + "/"
        files: [
            "animation/qparallelanimationgroup.h",
            "animation/qsequentialanimationgroup.h",
            "animation/qabstractanimation.h",
            "animation/qanimationgroup.h",
            "animation/qpropertyanimation.h",
            "animation/qvariantanimation.h",
            "animation/qpauseanimation.h",

            "kernel/qobject.h",
            "kernel/qsignalmapper.h",

            "io/qbuffer.h",
            "io/qfilesystemwatcher.h",
            "io/qprocess.h",
            "io/qfileselector.h",
            "io/qwinoverlappedionotifier_p.h",

            "itemmodels/qabstractproxymodel.h",
            "itemmodels/qitemselectionmodel.h",
            "itemmodels/qsortfilterproxymodel.h",
            "itemmodels/qidentityproxymodel.h",

            "statemachine/qstatemachine.h",
        ]
    }

    FileTagger {
        patterns: basePath + "/kernel/qtimer.h"
        fileTags: "moc_hpp_p"
    }

    Group {
        id: headers_no_moc
        name: "_headers_no_moc"
        fileTags: "header_sync"
        prefix: basePath + "/"
        files: {
            var files = [];

            // Don't sync specific platform headers
            if (!qbs.targetOS.contains("osx")) {
                files.push("io/qfilesystemwatcher_fsevents_p.h");
            }

            if (!qbs.targetOS.contains("windows")) {
                files.push("io/qwindowspipereader_p.h");
                files.push("io/qwindowspipewriter_p.h");
                files.push("io/qfilesystemwatcher_win_p.h");
                files.push("kernel/qeventdispatcher_win_p.h");
            }

            if (!qbs.targetOS.contains("winrt")) {
                files.push("kernel/qeventdispatcher_winrt_p.h");
            }

            if (!qbs.targetOS.contains("blackberry")) {
                files.push("kernel/qeventdispatcher_blackberry_p.h");
                files.push("kernel/qppsobject_p.h");
                files.push("tools/qlocale_blackberry.h");
            }

            if (!QtHost.config.glib) {
                files.push("kernel/qeventdispatcher_glib_p.h");
            }

            if (!QtHost.config.kqueue) {
                files.push("io/qfilesystemwatcher_kqueue_p.h");
            }

            return files;
        }
    }

    Group {
        name: "_headers"
        fileTags: ["moc_hpp", "header_sync"]
        prefix: basePath + "/"
        files: [
            "mimetypes/*.h",
            "statemachine/*.h",
            "global/*.h",
            "kernel/*.h",
            "arch/*.h",
            "json/*.h",
            "io/*.h",
            "tools/*.h",
            "itemmodels/*.h",
            "thread/*.h",
            "animation/*.h",
            "codecs/*.h",
            "plugin/*.h",
            "xml/*.h",
        ]
        excludeFiles: headers_moc_p.files.concat(headers_no_moc.files)
    }

    Group {
        name: "animation"
        prefix: basePath + "/animation/"
        files: "*.cpp"
    }

    Group {
        name: "codecs"
        prefix: basePath + "/codecs/"
        files: [
            "qbig5codec.cpp",
            "qeucjpcodec.cpp",
            "qeuckrcodec.cpp",
            "qgb18030codec.cpp",
            //"qiconvcodec.cpp", // ### iconv
            //"qicucodec.cpp",   // ### icu
            "qisciicodec.cpp",
            "qjiscodec.cpp",
            "qjpunicode.cpp",
            "qlatincodec.cpp",
            "qsimplecodec.cpp",
            "qsjiscodec.cpp",
            "qtextcodec.cpp",
            "qtsciicodec.cpp",
            "qutfcodec.cpp",
        ]
    }

    Group {
        name: "codecs_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/codecs/"
        files: [
            "qwindowscodec.cpp",
        ]
    }

    Group {
        name: "global"
        prefix: basePath + "/global/"
        files: [
            "qnumeric.cpp",
            "archdetect.cpp",
            "qglobal.cpp",
            "qglobalstatic.cpp",
            "qhooks.cpp",
            "qlibraryinfo.cpp",
            "qlogging.cpp",
            "qmalloc.cpp",
        ]
    }

    Group {
        name: "io"
        prefix: basePath + "/io/"
        files: [
            "qabstractfileengine.cpp",
            "qbuffer.cpp",
            "qdatastream.cpp",
            "qdataurl.cpp",
            "qdebug.cpp",
            "qdir.cpp",
            "qdiriterator.cpp",
            "qfile.cpp",
            "qfiledevice.cpp",
            "qfileinfo.cpp",
            "qfileselector.cpp",
            "qfilesystemengine.cpp",
            "qfilesystementry.cpp",
            "qfilesystemwatcher.cpp",
            //"qfilesystemwatcher_kqueue.cpp",  // ### mac (?)
            "qfilesystemwatcher_polling.cpp",
            "qfsfileengine.cpp",
            "qfsfileengine_iterator.cpp",
            "qiodevice.cpp",
            "qipaddress.cpp",
            "qlockfile.cpp",
            "qloggingcategory.cpp",
            "qloggingregistry.cpp",
            "qnoncontiguousbytedevice.cpp",
            "qprocess.cpp",
            //"qprocess_wince.cpp",             // ### wince
            "qresource.cpp",
            "qresource_iterator.cpp",
            "qsavefile.cpp",
            "qsettings.cpp",
            //"qsettings_mac.cpp",              // ### mac
            //"qsettings_winrt.cpp",            // ### winrt
            "qstandardpaths.cpp",
            //"qstandardpaths_android.cpp",     // ### android
            //"qstandardpaths_blackberry.cpp",  // ### blackberry
            //"qstandardpaths_winrt.cpp",       // ### winrt
            "qstorageinfo.cpp",
            //"qstorageinfo_mac.cpp",           // ### mac
            //"qstorageinfo_stub.cpp",          // ### all-else-fails
            "qtemporarydir.cpp",
            "qtemporaryfile.cpp",
            "qtextstream.cpp",
            "qtldurl.cpp",
            "qurl.cpp",
            "qurlidna.cpp",
            "qurlquery.cpp",
            "qurlrecode.cpp",
        ]
    }

    Group {
        name: "io_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: basePath + "/io/"
        files: [
            "forkfd_qt.cpp",
            "qfilesystemengine_unix.cpp",
            "qfilesystemiterator_unix.cpp",
            "qfilesystemwatcher_inotify.cpp",
            //"qfilesystemwatcher_kqueue.cpp",
            "qfsfileengine_unix.cpp",
            "qlockfile_unix.cpp",
            "qprocess_unix.cpp",
            "qstandardpaths_unix.cpp",
            "qstorageinfo_unix.cpp",
        ]
    }

    Group {
        name: "io_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/io/"
        files: [
            "qwinoverlappedionotifier.cpp",
            "qfilesystemengine_win.cpp",
            "qfilesystemwatcher_win.cpp",
            "qstandardpaths_win.cpp",
            "qsettings_win.cpp",
            "qfsfileengine_win.cpp",
            "qwindowspipereader.cpp",
            "qwindowspipewriter.cpp",
            "qfilesystemiterator_win.cpp",
            "qlockfile_win.cpp",
            "qstorageinfo_win.cpp",
            "qprocess_win.cpp",
        ]
    }

    Group {
        name: "itemmodels"
        prefix: basePath + "/itemmodels/"
        files: [
            "qabstractitemmodel.cpp",
            "qabstractproxymodel.cpp",
            "qidentityproxymodel.cpp",
            "qitemselectionmodel.cpp",
            "qsortfilterproxymodel.cpp",
            "qstringlistmodel.cpp",
        ]
    }

    Group {
        name: "json"
        prefix: basePath + "/json/"
        files: [
            "qjson.cpp",
            "qjsonarray.cpp",
            "qjsondocument.cpp",
            "qjsonobject.cpp",
            "qjsonparser.cpp",
            "qjsonvalue.cpp",
            "qjsonwriter.cpp",
        ]
    }

    Group {
        name: "kernel"
        prefix: basePath + "/kernel/"
        files: [
            //"qeventdispatcher_winrt.cpp", // ### winrt
            "qeventloop.cpp",
            //"qfunctions_nacl.cpp",        // ### nacl
            //"qfunctions_vxworks.cpp",     // ### vxworks
            //"qfunctions_wince.cpp",       // ### wince
            //"qfunctions_winrt.cpp",       // ### winrt
            //"qjni.cpp",                   // ### jni
            //"qjnihelpers.cpp",            // ### jni
            //"qjnionload.cpp",             // ### jni
            "qmath.cpp",
            "qmetaobject.cpp",
            "qmetaobjectbuilder.cpp",
            "qmetatype.cpp",
            "qmimedata.cpp",
            "qobject.cpp",
            "qobjectcleanuphandler.cpp",
            "qpointer.cpp",
            //"qppsattribute.cpp",          // ### bb
            //"qppsobject.cpp",             // ### bb
            "qsharedmemory.cpp",
            //"qsharedmemory_android.cpp",  // ### android
            "qsignalmapper.cpp",
            "qsocketnotifier.cpp",
            "qsystemerror.cpp",
            "qsystemsemaphore.cpp",
            //"qsystemsemaphore_android.cpp",//### android
            //"qtcore_eval.cpp",            // ### needs to be handled by config, and use licensing

            "qtimer.cpp",
            "qtranslator.cpp",
            "qvariant.cpp",
            "qabstracteventdispatcher.cpp",
            "qabstractnativeeventfilter.cpp",
            "qbasictimer.cpp",
            //"qcore_mac.cpp",              // ### mac
            "qcoreapplication.cpp",
            //"qcoreapplication_mac.cpp",   // ### mac
            "qcoreevent.cpp",
            "qcoreglobaldata.cpp",
            //"qeventdispatcher_blackberry.cpp", // ### bb
            //"qeventdispatcher_glib.cpp",       // ### glib
        ]
    }

    Group {
        name: "kernel_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: basePath + "/kernel/"
        files: [
            "qcore_unix.cpp",
            "qcrashhandler.cpp",
            "qeventdispatcher_unix.cpp",
            "qtimerinfo_unix.cpp",
            "qsystemsemaphore_posix.cpp",
            "qsystemsemaphore_systemv.cpp",
            "qsystemsemaphore_unix.cpp",
            "qsharedmemory_posix.cpp",
            "qsharedmemory_systemv.cpp",
            "qsharedmemory_unix.cpp",
        ]
    }

    Group {
        name: "kernel_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/kernel/"
        files: [
            "qcoreapplication_win.cpp",
            "qeventdispatcher_win.cpp",
            "qsystemsemaphore_win.cpp",
            "qsharedmemory_win.cpp",
            "qwineventnotifier.cpp",
        ]
    }

    Group {
        name: "mimetypes"
        prefix: basePath + "/mimetypes/"
        files: [
            "mimetypes.qrc",
            "qmimedatabase.cpp",
            "qmimeglobpattern.cpp",
            "qmimemagicrule.cpp",
            "qmimemagicrulematcher.cpp",
            "qmimeprovider.cpp",
            "qmimetype.cpp",
            "qmimetypeparser.cpp",
        ]
    }

    Group {
        name: "plugin"
        prefix: basePath + "/plugin/"
        files: [
            "qelfparser_p.cpp",
            "qfactoryloader.cpp",
            "qlibrary.cpp",
            "qmachparser.cpp",
            "qpluginloader.cpp",
            "quuid.cpp",
        ]
    }

    Group {
        name: "plugin_unix"
        prefix: basePath + "/plugin/"
        files: [
            "qlibrary_unix.cpp",
        ]
    }

    Group {
        name: "plugin_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/plugin/"
        files: [
            "qlibrary_win.cpp",
            "qsystemlibrary.cpp",
        ]
    }

    Group {
        name: "statemachine"
        prefix: basePath + "/statemachine/"
        files: [
            "qabstractstate.cpp",
            "qabstracttransition.cpp",
            "qeventtransition.cpp",
            "qfinalstate.cpp",
            "qhistorystate.cpp",
            "qsignaltransition.cpp",
            "qstate.cpp",
            "qstatemachine.cpp",
        ]
    }

    Group {
        name: "thread"
        prefix: basePath + "/thread/"
        files: [
            "qatomic.cpp",
            "qexception.cpp",
            "qfutureinterface.cpp",
            "qfuturewatcher.cpp",
            "qmutex.cpp",
            "qmutexpool.cpp",
            "qreadwritelock.cpp",
            "qresultstore.cpp",
            "qrunnable.cpp",
            "qsemaphore.cpp",
            "qthread.cpp",
            //"qthread_winrt.cpp",  // ### winrt
            "qthreadpool.cpp",
            "qthreadstorage.cpp",
            "qthread_unix.cpp",
            "qwaitcondition_unix.cpp",
        ]
    }

    Group {
        name: "thread_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/thread/"
        files: [
            "qwaitcondition_win.cpp",
            "qthread_win.cpp",
        ]
    }

    Group {
        name: "tools"
        prefix: basePath + "/tools/"
        files: [
            "qarraydata.cpp",
            "qbitarray.cpp",
            "qbytearray.cpp",
            "qbytearraylist.cpp",
            "qbytearraymatcher.cpp",
            "qcollator.cpp",
            //"qcollator_icu.cpp",     // ### icu
            //"qcollator_macx.cpp",    // ### macx
            "qcommandlineoption.cpp",
            "qcommandlineparser.cpp",
            "qcontiguouscache.cpp",
            "qcryptographichash.cpp",
            "qdatetime.cpp",
            "qdatetimeparser.cpp",
            "qeasingcurve.cpp",
            "qelapsedtimer.cpp",
            //"qelapsedtimer_generic.cpp", // ### !win32
            //"qelapsedtimer_mac.cpp",  // ### mac
            "qfreelist.cpp",
            "qharfbuzz.cpp",
            "qhash.cpp",
            "qline.cpp",
            "qlinkedlist.cpp",
            "qlist.cpp",
            "qlocale.cpp",
            //"qlocale_blackberry.cpp", // ### bb
            //"qlocale_icu.cpp",        // ### icu
            "qlocale_tools.cpp",
            "qmap.cpp",
            "qmargins.cpp",
            "qmessageauthenticationcode.cpp",
            "qpoint.cpp",
            "qqueue.cpp",
            "qrect.cpp",
            "qrefcount.cpp",
            "qregexp.cpp",
            "qregularexpression.cpp",
            "qscopedpointer.cpp",
            "qscopedvaluerollback.cpp",
            "qshareddata.cpp",
            "qsharedpointer.cpp",
            "qsimd.cpp",
            "qsize.cpp",
            "qstack.cpp",
            "qstring.cpp",
            "qstring_compat.cpp",
            "qstringbuilder.cpp",
            "qstringlist.cpp",
            "qtextboundaryfinder.cpp",
            "qtimeline.cpp",
            "qtimezone.cpp",
            "qtimezoneprivate.cpp",
            //"qtimezoneprivate_android.cpp", // ### android
            //"qtimezoneprivate_icu.cpp",     // ### icu
            "qunicodetools.cpp",
            "qvector.cpp",
            "qversionnumber.cpp",
            "qvsnprintf.cpp",
        ]
    }

    Group {
        name: "tools_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: basePath + "/tools/"
        files: [
            "qelapsedtimer_unix.cpp",
            "qcollator_posix.cpp",
            "qlocale_unix.cpp",
            "qtimezoneprivate_tz.cpp",
        ]
    }

    Group {
        name: "tools_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/tools/"
        files: [
            "qlocale_win.cpp",
            "qcollator_win.cpp",
            "qelapsedtimer_win.cpp",
            "qtimezoneprivate_win.cpp",
            "qvector_msvc.cpp",
        ]
    }

    Group {
        name: "xml"
        prefix: basePath + "/xml/"
        files: [
            "qxmlstream.cpp",
            "qxmlutils.cpp",
        ]
    }
}
