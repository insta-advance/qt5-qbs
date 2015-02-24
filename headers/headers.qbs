import qbs

Project {
    name: "headers"

    QtHeaders {
        name: "QtCoreHeaders"
        QtCoreHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtGuiHeaders"
        QtGuiHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtNetworkHeaders"
        QtNetworkHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformHeaders"
        QtPlatformHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformSupport"
        QtPlatformSupport { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQmlHeaders"
        QtQmlHeaders { fileTags: "header_sync" }
    }
}
