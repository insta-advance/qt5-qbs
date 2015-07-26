import qbs
import qbs.File
import qbs.Probes

QtModule {
    name: "QtTest"
    simpleName: "testlib"

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/testlib/"

    cpp.defines: [
        "QT_BUILD_TESTLIB_LIB",
    ].concat(base)

    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtTestHeaders" }
    Depends { name: "QtCore" }

    QtTestHeaders {
        name: "headers"
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "qabstracttestlogger.cpp",
            "qasciikey.cpp",
            "qbenchmark.cpp",
            "qbenchmarkevent.cpp",
            "qbenchmarkmeasurement.cpp",
            "qbenchmarkmetric.cpp",
            "qbenchmarkperfevents.cpp",
            "qbenchmarkvalgrind.cpp",
            "qcsvbenchmarklogger.cpp",
            "qplaintestlogger.cpp",
            "qsignaldumper.cpp",
            "qtestblacklist.cpp",
            "qtestcase.cpp",
            "qtestdata.cpp",
            "qtestelement.cpp",
            "qtestelementattribute.cpp",
            "qtestlog.cpp",
            "qtestresult.cpp",
            "qtesttable.cpp",
            "qtestxunitstreamer.cpp",
            "qxmltestlogger.cpp",
            "qxunittestlogger.cpp",
        ]
    }
}
