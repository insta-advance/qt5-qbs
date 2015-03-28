import qbs

QtPlugin {
    targetName: "qsvg"
    category: "imageformats"

    includeDependencies: ["QtCore", "QtGui", "QtSvg"]

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtSvg" }

    Group {
        name: "headers"
        prefix: configure.sourcePath + "/qtsvg/src/plugins/imageformats/svg/"
        files: "*.h"
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: configure.sourcePath + "/qtsvg/src/plugins/imageformats/svg/"
        files: "*.cpp"
        fileTags: "moc"
        overrideTags: false
    }
}
