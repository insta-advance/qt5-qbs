import qbs

QtPlugin {
    targetName: "qsvg"
    category: "imageformats"
    condition: project.svg !== false

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtSvg" }

    Group {
        name: "headers"
        prefix: project.sourceDirectory + "/qtsvg/src/plugins/imageformats/svg/"
        files: "*.h"
    }

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtsvg/src/plugins/imageformats/svg/"
        files: "*.cpp"
    }
}
