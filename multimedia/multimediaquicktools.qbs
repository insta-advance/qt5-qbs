import qbs

QtModule {
    name: "QtMultimediaQuickTools"

    includeDependencies: ["QtCore", "QtMultimedia-private"]

    cpp.defines: [
        "QT_BUILD_QTMM_QUICK_LIB",
    ].concat(base)

    Depends { name: "opengl" }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtMultimedia" }
    Depends { name: "QtQuick" }

    Group {
        name: "headers"
        prefix: configure.sourcePath + "/qtmultimedia/src/"
        files: [
            "multimedia/qtmultimediaquicktools_headers/*.h",
            "qtmultimediaquicktools/*.h",
        ]
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtmultimedia/src/qtmultimediaquicktools/"
        files: "*.cpp"
        fileTags: "moc"
        overrideTags: false
    }
}
