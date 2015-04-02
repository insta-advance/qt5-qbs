import qbs
import qbs.File

Project {
    name: "headers"

    QtHeaders {
        name: "QtCoreHeaders"
        module: "QtCore"
        QtCoreHeaders { fileTags: "header_sync" }

        // Copy dummy headers
        Group {
            name: "dummy headers"
            prefix: project.sourceDirectory + "/include/QtCore/"
            files: [ "qconfig.h", "qfeatures.h" ]
            fileTags: "hpp_dummy"
        }

        Rule {
            inputs: "hpp_dummy"
            Artifact {
                filePath: project.buildDirectory + "/include/QtCore/" + input.fileName
                fileTags: "hpp"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.silent = true;
                cmd.sourceCode = function() {
                    File.copy(input.filePath, output.filePath);
                };
                return cmd;
            }
        }
    }

    QtHeaders {
        name: "QtGuiHeaders"
        module: "QtGui"
        QtGuiHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtNetworkHeaders"
        module: "QtNetwork"
        QtNetworkHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtWidgetHeaders"
        module: "QtWidgets"
        QtWidgetHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformHeaders"
        module: "QtPlatformHeaders"
        QtPlatformHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformSupport"
        module: "QtPlatformSupport"
        QtPlatformSupport { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQmlHeaders"
        module: "QtQml"
        QtQmlHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQuickHeaders"
        module: "QtQuick"
        QtQuickHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtMultimediaHeaders"
        module: "QtMultimedia"
        QtMultimediaHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtMultimediaWidgetsHeaders"
        module: "QtMultimediaWidgets"
        QtMultimediaWidgetsHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtSvgHeaders"
        module: "QtSvg"
        QtSvgHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtTestHeaders"
        module: "QtTest"
        QtTestHeaders { fileTags: "header_sync" }
    }
}
