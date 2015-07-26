import qbs
import qbs.File
import qbs.FileInfo
import qbs.TextFile

Project {
    name: "QtQuickControls"
    condition: File.exists(project.sourceDirectory + "/qtquickcontrols")

    QmlPlugin {
        name: "QtQuickControls"
        condition: project.quickcontrols !== false
        targetName: "qtquickcontrolsplugin"
        pluginPath: "QtQuick/Controls"

        readonly property string basePath: project.sourceDirectory + "/qtquickcontrols/src/controls"

        cpp.defines: {
            var defines = base;
            if (project.widgets !== false)
                defines.push("QT_NO_WIDGETS");
            return defines;
        }

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }
        Depends { name: "QtWidgets"; condition: project.widgets }

        Group {
            name: "headers"
            prefix: basePath + '/'
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
            prefix: basePath + '/'
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
            prefix: basePath + "/"
            files: "qmldir"
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }

        Group {
            name: "qml"
            prefix: basePath + '/'
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
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine("<RCC>");
                    file.writeLine('<qresource prefix="/QtQuick/Controls">');
                    for (var i in inputs.qml) {
                        var relativeIn = FileInfo.relativePath(product.basePath, inputs.qml[i].filePath);
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
        condition: project.quickcontrols !== false
        type: "qml" // no library, only installs
        pluginPath: "QtQuick/Controls/Private"

        readonly property string basePath: project.sourceDirectory + "/qtquickcontrols/src/controls/Private"

        Group {
            name: "qml"
            prefix: basePath + "/"
            files: ["qmldir", "**/*.qml", "**/*.js"]
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }

    QmlPlugin {
        name: "QtQuick.Controls.Styles"
        condition: project.quickcontrols !== false
        type: "qml" // no library, only installs
        pluginPath: "QtQuick/Controls/Styles"

        readonly property string basePath: project.sourceDirectory + "/qtquickcontrols/src/controls/Styles"

        /*Group {
            name: "qml"
            prefix: basePath + "/"
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
            prefix: basePath + "/"
            files: ["qmldir", "Base"]
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }

    QmlPlugin {
        name: "QtQuick.Layouts"
        condition: project.quickcontrols !== false
        targetName: "qquicklayoutsplugin"
        pluginPath: "QtQuick/Layouts"

        readonly property string basePath: project.sourceDirectory + "/qtquickcontrols/src/layouts"

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }

        Group {
            name: "headers"
            prefix: basePath + '/'
            files: "*.h"
        }

        Group {
            name: "sources"
            prefix: basePath + '/'
            files: "*.cpp"
        }

        Group {
            name: "qmldir"
            prefix: basePath + "/"
            files: "qmldir"
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }
    }
}
