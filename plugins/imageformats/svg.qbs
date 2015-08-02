import qbs

QtPlugin {
    targetName: "qsvg"
    category: "imageformats"
    condition: project.svg !== false

    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "Qt.svg" }

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
