import qbs

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
    }
}
