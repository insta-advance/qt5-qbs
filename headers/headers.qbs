import qbs

Project {
    name: "headers"

    QtHeaders {
        name: "QtCoreHeaders"
        module: "QtCore"
        QtCoreHeaders { fileTags: "header_sync" }
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
}
