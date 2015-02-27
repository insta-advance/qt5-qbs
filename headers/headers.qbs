import qbs
import qbs.Process
import qbs.TextFile

Project {
    name: "headers"

    QtHeaders {
        name: "QtCoreHeaders"
        QtHost.sync.module: "QtCore"
        QtCoreHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtGuiHeaders"
        QtHost.sync.module: "QtGui"
        QtGuiHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtNetworkHeaders"
        QtHost.sync.module: "QtNetwork"
        QtNetworkHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformHeaders"
        QtHost.sync.module: "QtPlatformHeaders"
        QtPlatformHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformSupport"
        QtHost.sync.module: "QtPlatformSupport"
        QtPlatformSupport { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQmlHeaders"
        QtHost.sync.module: "QtQml"
        QtQmlHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQuickHeaders"
        QtHost.sync.module: "QtQuick"
        QtQuickHeaders { fileTags: "header_sync" }

        // ### move to masm, and make sure masm can build without constantly regenerating this
        // ... this might need to become a probe
        Transformer {
            Artifact {
                filePath: project.buildDirectory + "/include/QtQml/RegExpJitTables.h"
                fileTags: "hpp"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + output.fileName;
                cmd.masmPath = project.sourceDirectory + "/qtdeclarative/src/3rdparty/masm";
                cmd.sourceCode = function() {
                    var process = new Process();
                    process.setWorkingDirectory(masmPath);
                    var exitCode = process.exec("python", ["create_regex_tables"], true);
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.write(process.readStdOut());
                    process.close();
                    file.close();
                };
                return cmd;
            }
        }
    }
}
