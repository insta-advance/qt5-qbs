import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile

QtModuleProject {
    id: module
    condition: project.quickcontrols
    name: "QtQuickControls"
    simpleName: "quickcontrols"
    prefix: project.sourceDirectory + "/qtquickcontrols/src/controls/"

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

    QmlPlugin {
        name: module.moduleName
        targetName: "qtquickcontrolsplugin"
        pluginPath: "QtQuick/Controls"

        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.qml" }
        Depends { name: "Qt.quick" }
        Depends { name: "Qt.widgets"; condition: project.widgets }

        cpp.defines: {
            var defines = base;
            if (project.widgets !== false)
                defines.push("QT_NO_WIDGETS");
            return defines;
        }

        cpp.includePaths: module.includePaths.concat(base)

        Group {
            name: "headers"
            prefix: module.prefix
            files: [
                "*.h",
                "Private/*.h",
            ]
            excludeFiles: {
                var excludeFiles = [];
                if (!project.widgets) {
                    excludeFiles.push("Private/qquickstyleitem_p.h");
                }
                return excludeFiles;
            }
        }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "*.cpp",
                "Private/*.cpp",
            ]
            excludeFiles: {
                var excludeFiles = [];
                if (!project.widgets) {
                    excludeFiles.push("Private/qquickstyleitem.cpp");
                }
                return excludeFiles;
            }
        }

        Group {
            name: "qmldir"
            prefix: module.prefix
            files: "qmldir"
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }

        Group {
            name: "qml"
            prefix: module.prefix
            files: "*.qml"
            fileTags: "qml"
            overrideTags: false
        }

        Rule {
            inputs: "qml"
            multiplex: true
            Artifact {
                filePath: "controls.qrc"
                fileTags: "qrc"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + output.fileName;
                cmd.highlight = "codegen";
                cmd.prefix = module.prefix;
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine("<RCC>");
                    file.writeLine('<qresource prefix="/QtQuick/Controls">');
                    for (var i in inputs.qml) {
                        var relativeIn = FileInfo.relativePath(prefix, inputs.qml[i].filePath);
                        var relativeOut = FileInfo.relativePath(product.buildDirectory, inputs.qml[i].filePath);
                        file.writeLine('    <file alias="' + relativeIn + '">' + relativeOut + '</file>');
                    }
                    file.writeLine("</qresource>");
                    file.writeLine("</RCC>");
                    file.close();
                };
                return cmd;
            }
        }
    }

    QmlPlugin {
        name: "QtQuickControls.Private"
        type: "qml" // no library, only installs
        pluginPath: "QtQuick/Controls/Private"

        Group {
            name: "qml"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/controls/Private/"
            files: ["qmldir", "**/*.qml", "**/*.js"]
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }

    QmlPlugin {
        name: "QtQuick.Controls.Styles"
        type: "qml" // no library, only installs
        pluginPath: "QtQuick/Controls/Styles"

        /*Group {
            name: "qml"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/controls/Styles/"
            files: ["qmldir", "*.qml"]
            excludeFiles: {
                var excludeFiles = ["doc/**"];
                if (!qbs.targetOS.contains("android"))
                    excludeFiles.push("Android/**");
                if (!qbs.targetOS.contains("winrt"))
                    excludeFiles.push("WinRT/**");
                if (!qbs.targetOS.contains("iOS"))
                    excludeFiles.push("iOS/**");
                return excludeFiles;
            }
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }*/

        Group {
            name: "files"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/controls/Styles/"
            files: ["qmldir", "Base"]
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }

    QmlPlugin {
        name: "QtQuick.Layouts"
        targetName: "qquicklayoutsplugin"
        pluginPath: "QtQuick/Layouts"

        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.qml" }
        Depends { name: "Qt.quick" }

        Group {
            name: "headers"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/layouts/"
            files: "*.h"
        }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/layouts/"
            files: "*.cpp"
        }

        Group {
            name: "qmldir"
            prefix: project.sourceDirectory + "/qtquickcontrols/src/layouts/"
            files: "qmldir"
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }
}
