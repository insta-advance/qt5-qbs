import qbs

QtModule {
    name: "QtQuick"
    readonly property path basePath: project.sourceDirectory
                                     + "/qtdeclarative/src/quick"

    Depends { name: "QtQml" }
}
