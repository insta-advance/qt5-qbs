import qbs
import qbs.File
import qbs.FileInfo

Product {
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
        project.sourceDirectory + "/qtbase/mkspecs/" + project.host,
        //project.sourceDirectory + "/include",
    ]

    type: "staticlibrary"
    Depends { name: "cpp" }
    Depends { name: "QtHost"; submodules: ["config", "includes"] }
    QtHost.includes.modules: [ "core", "core-private", "xml", "xml-private" ]

    cpp.defines: bootstrapDefines.concat([
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

    // Perform a minimal header installation (c.f. syncqt)
    // ### do this with QtHost.sync now
    Group {
        name: "sync_headers"
        fileTags: "sync_headers"
        prefix: project.sourceDirectory + "/qtbase/src/corelib/"
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

    Group {
        name: "xml_headers"
        fileTags: "sync_headers"
        prefix: project.sourceDirectory + "/qtbase/src/xml/"
        files: [
            "dom/qdom.h",
            "qtxmlglobal.h",
            "sax/qxml.h",
            "sax/qxml_p.h",
        ]
    }

    Rule {
        inputs: [ "sync_headers" ]
        Artifact {
            fileTags: "hpp"
            filePath: {
                var module = FileInfo.relativePath(project.sourceDirectory + "/qtbase/src/", input.filePath);
                if (module.startsWith("corelib"))
                    module = "Core";
                else if (module.startsWith("xml"))
                    module = "Xml";

                return project.buildDirectory + "/include/Qt" + module
                    + (input.fileName.endsWith("_p.h") ? "/private/" : "/")
                    + input.fileName;
            }
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.silent = true;
            cmd.sourceCode = function() {
                File.copy(input.filePath, output.filePath);
            }
            return cmd;
        }
    }

    Group {
        name: "minimal_headers"
        fileTags: "sync_minimal"
        prefix: project.sourceDirectory + "/include/"
        files: [
            "QtCore/*",
            "QtXml/*",
        ]
    }

    Rule {
        inputs: [ "sync_minimal" ]
        Artifact {
            fileTags: "hpp"
            filePath: {
                var path = FileInfo.relativePath(project.sourceDirectory + "/include/", input.filePath);
                return project.buildDirectory + "/include/" + path;
            }
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.silent = true;
            cmd.sourceCode = function() {
                File.copy(input.filePath, output.filePath);
            }
            return cmd;
        }
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

    Group {
        name: "xml_sources"
        prefix: project.sourceDirectory + "/qtbase/src/xml/"
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
