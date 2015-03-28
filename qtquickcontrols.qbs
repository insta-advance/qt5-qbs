import qbs
import qbs.TextFile

Project {
    name: "QtQuickControls"

    QmlPlugin {
        name: "QtQuickControls"
        targetName: "qtquickcontrolsplugin"
        pluginPath: "QtQuick.2"

        readonly property string basePath: configure.sourcePath + "/qtquickcontrols/src/controls"

        includeDependencies: ["QtCore-private", "QtGui-private", "QtQml-private", "QtQuick-private", "QtWidgets"]

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }
        Depends { name: "QtWidgets" }

        Group {
            name: "headers"
            prefix: basePath + '/'
            files: [
                "*.h",
                "Private/*.h",
            ]
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "sources"
            prefix: basePath + '/'
            files: [
                "*.cpp",
                "Private/*.cpp",
            ]
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "qml"
            prefix: basePath + '/'
            files: [
                "*.qml",
                //"qmldir",
                "Styles/Base/*.qml",
            ]
            fileTags: "qml"
            overrideTags: false
        }

        Rule {
            inputs: "qml"
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
                        file.writeLine('<file alias="' + inputs.qml[i].fileName + '">' + inputs.qml[i].filePath + '</file>');
                    }
                    file.writeLine("</qresource>");
                    file.writeLine("</RCC>");
                    file.close();
                };
                return cmd;
            }
        }
    }
}
