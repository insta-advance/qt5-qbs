import qbs
import "headers/QtQuickTestHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    condition: project.qmltest
    name: "QtQuickTest"
    simpleName: "qmltest"
    prefix: project.sourceDirectory + "/qtbase/src/qmltest/"

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
        ModuleHeaders { fileTags: "header_sync" }
    }

    QtModule {
        name: module.moduleName
        simpleName: "qmltest"
        targetName: module.targetName

        Export {
            Depends { name: "cpp" }
            cpp.includePaths: module.publicIncludePaths
        }

        Depends { name: module.headersName }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.qml" }
        Depends { name: "Qt.quick" }
        Depends { name: "Qt.testlib" }

        cpp.defines: [
            "QT_QUICKTEST_LIB", "QT_GUI_LIB",
        ].concat(base)

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders { }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "*.cpp",
            ]
        }
    }

    Project {
        name: "imports"
        QmlPlugin {
            condition: project.qmltest !== false
            targetName: "qmltestplugin"
            pluginPath: "QtTest"

            Depends { name: "Qt.core" }
            Depends { name: "Qt.gui" }
            Depends { name: "Qt.qml" }
            Depends { name: "Qt.testlib" }
            Depends { name: "Qt.qmltest" }

            Group {
                name: "sources"
                prefix: project.sourceDirectory + "/qtdeclarative/src/imports/testlib/"
                files: "main.cpp"
            }

            Group {
                name: "qml"
                prefix: project.sourceDirectory + "/qtdeclarative/src/imports/testlib/"
                files: ["qmldir", "*.qml", "*.js"]
                qbs.install: true
                qbs.installDir: "qml/" + pluginPath
            }
        }
    }
}
