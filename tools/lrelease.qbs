import qbs

QtHostTool {
    destinationDirectory: project.buildDirectory + "/bin"

    Depends { name: "QtBootstrap" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtXmlHeaders" }

    cpp.includePaths: [
        project.sourceDirectory + "/qttools/src/linguist/lrelease",
        project.sourceDirectory + "/qttools/src/linguist/shared",
    ].concat(base)

    cpp.defines: [
        "PROEVALUATOR_INIT_PROPS",
        "PROEVALUATOR_CUMULATIVE",
    ].concat(base)

    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: "bin"
    }

    Group {
        name: "source"
        prefix: project.sourceDirectory + "/qttools/src/linguist/"
        files: [
            "lrelease/main.cpp",
            "lrelease/lrelease.1",
            "shared/numerus.cpp",
            "shared/translator.h",
            "shared/translator.cpp",
            "shared/translatormessage.h",
            "shared/translatormessage.cpp",
            "shared/qm.cpp",
            "shared/qph.cpp",
            "shared/po.cpp",
            "shared/ts.cpp",
            "shared/xliff.cpp",
            "shared/ioutils.cpp",
            "shared/qmakevfs.cpp",
            "shared/proitems.cpp",
            "shared/qmakeglobals.cpp",
            "shared/qmakeparser.cpp",
            "shared/qmakeevaluator.cpp",
            "shared/qmakebuiltins.cpp",
            "shared/profileevaluator.cpp",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "shell32",
            "ole32",
        ]
    }
}

