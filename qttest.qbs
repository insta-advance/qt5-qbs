import qbs
import "headers/QtTestHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    name: "QtTest"
    simpleName: "testlib"
    prefix: project.sourceDirectory + "/qtbase/src/testlib/"

    Product {
        name: module.privateName
        profiles: project.targetProfiles
        type: "hpp"
        Depends { name: module.moduleName }
        Export {
            Depends { name: "cpp" }
            cpp.defines: module.defines
            cpp.includePaths: module.includePaths
        }
    }

    QtHeaders {
        name: module.headersName
        sync.module: module.name
        sync.classNames: ({
            "qtest.h": ["QTest"],
        })
        ModuleHeaders { fileTags: "header_sync" }
    }

    QtModule {
        id: library
        name: module.moduleName
        targetName: module.targetName
        simpleName: module.simpleName

        Export {
            Depends { name: "cpp" }
            cpp.includePaths: module.publicIncludePaths
        }

        Depends { name: module.headersName }
        Depends { name: "Qt.core" }

        cpp.defines: [
            "QT_BUILD_TESTLIB_LIB",
        ].concat(base)

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders { }

        Group {
            name: "sources"
            prefix: module.prefix
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
}
