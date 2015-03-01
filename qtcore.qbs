import qbs
import qbs.TextFile

QtModule {
    name: "QtCore"
    property path basePath: project.sourceDirectory + "/qtbase/src/corelib"

    Depends { name: "configure" }
    Depends { name: "QtCoreHeaders" }
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

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
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
        fileTags: "moc_hpp_p"
    }

    Group {
        id: headers_moc_qtimer
        name: "headers (QTimer)"
        fileTags: ["moc_hpp_p", "moc_hpp"]
        prefix: basePath + "/"
        files: "kernel/qtimer.h"
    }

    QtCoreHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: {
            var files = headers_moc_p.files.concat(headers_moc_qtimer.files);

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
        name: "mimetypes.qrc"
        files: basePath + "/mimetypes/mimetypes.qrc"
        fileTags: "qrc"
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "animation/*.cpp",
            "codecs/*.cpp",
            "global/*.cpp",
            "io/*.cpp",
            "itemmodels/*.cpp",
            "json/*.cpp",
            "kernel/*.cpp",
            "mimetypes/*.cpp",
            "plugin/*.cpp",
            "statemachine/*.cpp",
            "thread/*.cpp",
            "tools/*.cpp",
            "xml/*.cpp",
        ]
        excludeFiles: {
            var excludeFiles = [
                "codecs/qiconvcodec.cpp", // ### iconv
                "codecs/qicucodec.cpp",   // ### icu
                "codecs/qwindowscodec.cpp", // ## windows
                "io/qfilesystemwatcher_kqueue.cpp",  // ### mac
                "io/qprocess_wince.cpp",             // ### wince
                "io/qsettings_mac.cpp",              // ### mac
                "io/qsettings_winrt.cpp",            // ### winrt
                "io/qstandardpaths_android.cpp",     // ### android
                "io/qstandardpaths_blackberry.cpp",  // ### blackberry
                "io/qstandardpaths_winrt.cpp",       // ### winrt
                "io/qstorageinfo_mac.cpp",           // ### mac
                "io/qstorageinfo_stub.cpp",          // ### all-else-fails
                "kernel/qcoreapplication_mac.cpp",   // ### mac
                "kernel/qcore_mac.cpp",              // ### mac
                "kernel/qeventdispatcher_blackberry.cpp", // ### bb
                "kernel/qeventdispatcher_glib.cpp",       // ### glib
                "kernel/qeventdispatcher_winrt.cpp", // ### winrt
                "kernel/qfunctions_nacl.cpp",        // ### nacl
                "kernel/qfunctions_vxworks.cpp",     // ### vxworks
                "kernel/qfunctions_wince.cpp",       // ### wince
                "kernel/qfunctions_winrt.cpp",       // ### winrt
                "kernel/qjni.cpp",                   // ### jni
                "kernel/qjnihelpers.cpp",            // ### jni
                "kernel/qjnionload.cpp",             // ### jni
                "kernel/qppsattribute.cpp",          // ### bb
                "kernel/qppsobject.cpp",             // ### bb
                "kernel/qsharedmemory_android.cpp",  // ### android
                "kernel/qsystemsemaphore_android.cpp",//### android
                "kernel/qtcore_eval.cpp",            // ### needs to be handled by config, and use licensing
                "thread/qthread_winrt.cpp",  // ### winrt
                "tools/qcollator_icu.cpp",     // ### icu
                "tools/qcollator_macx.cpp",    // ### macx
                "tools/qelapsedtimer_generic.cpp", // ### !win32
                "tools/qelapsedtimer_mac.cpp",  // ### mac
                "tools/qlocale_blackberry.cpp", // ### bb
                "tools/qlocale_icu.cpp",        // ### icu
                "tools/qtimezoneprivate_android.cpp", // ### android
                "tools/qtimezoneprivate_icu.cpp",     // ### icu
                // included inline
                "thread/qmutex_linux.cpp",
                "thread/qmutex_mac.cpp",
                "thread/qmutex_unix.cpp",
                "thread/qmutex_win.cpp",
                "tools/qchar.cpp",
                "tools/qunicodetables.cpp",
                "tools/qstringmatcher.cpp",
            ].concat(sources_moc.files);

            if (!qbs.targetOS.contains("unix")) {
                Array.prototype.push.apply(excludeFiles, [
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
                    "tools/qelapsedtimer_unix.cpp",
                    "tools/qcollator_posix.cpp",
                    "tools/qlocale_unix.cpp",
                    "tools/qtimezoneprivate_tz.cpp",
                ]);
            }

            if (!qbs.targetOS.contains("windows")) {
                Array.prototype.push.apply(excludeFiles, [
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
                    "thread/qmutex_win.cpp",
                    "thread/qthread_win.cpp",
                    "tools/qlocale_win.cpp",
                    "tools/qcollator_win.cpp",
                    "tools/qelapsedtimer_win.cpp",
                    "tools/qtimezoneprivate_win.cpp",
                    "tools/qvector_msvc.cpp",
                ]);
            }

            if (!qbs.targetOS.contains("haiku")) {
                Array.prototype.push.apply(excludeFiles, [
                    "io/qstandardpaths_haiku.cpp",
                ]);
            }

            return excludeFiles;
        }
    }

    Group {
        id: sources_moc
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
            "kernel/qtimer.cpp",
            "statemachine/qstatemachine.cpp",
        ]
        fileTags: "moc_cpp"
        overrideTags: false
    }

    Export {
        Depends { name: "QtHost.includes" }
        QtHost.includes.modules: ["core", "core-private"]
    }
}
