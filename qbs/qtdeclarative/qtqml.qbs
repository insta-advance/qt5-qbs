import qbs

QtModule {
    name: "QtQml"

    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }

    QtHost.includes.modules: [ "qml", "qml-private" ]

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtdeclarative/src/qml/"
        files: [
            "qml/*.cpp",
        ]
    }

}
