import qbs
import qbs.File
import qbs.TextFile

Project {
    name: "QtQuickControls"
    condition: File.exists(project.sourcePath + "/qtquickcontrols")

    QmlPlugin {
        name: "QtQuickControls"
        condition: configure.quickcontrols
        targetName: "qtquickcontrolsplugin"
        pluginPath: "QtQuick/Controls"

        readonly property string basePath: project.sourcePath + "/qtquickcontrols/src/controls"

        includeDependencies: ["QtCore-private", "QtGui-private", "QtQml-private", "QtQuick-private", "QtWidgets"]

        cpp.defines: {
            var defines = base;
            if (!configure.widgets)
                defines.push("QT_NO_WIDGETS");
            return defines;
        }

        Depends { name: "QtCore" }
        Depends { name: "QtGui" }
        Depends { name: "QtQml" }
        Depends { name: "QtQuick" }
        Depends { name: "QtWidgets"; condition: configure.widgets }

        Group {
            name: "headers"
            prefix: basePath + '/'
            files: [
                "*.h",
                "Private/*.h",
            ]
            excludeFiles: {
                var excludeFiles = [];
                if (!configure.widgets) {
                    excludeFiles.push("Private/qquickstyleitem_p.h");
                }
                return excludeFiles;
            }
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
            excludeFiles: {
                var excludeFiles = [];
                if (!configure.widgets) {
                    excludeFiles.push("Private/qquickstyleitem.cpp");
                }
                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }

        Group {
            name: "qml"
            prefix: basePath + "/"
            files: "qmldir"
            qbs.install: true
            qbs.installDir: "qml/" + pluginPath
        }

        Group {
            name: "qml"
            prefix: basePath + '/'
            files: [
                "*.qml",
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
