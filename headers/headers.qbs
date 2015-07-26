import qbs
import qbs.File

Project {
    name: "headers"

    /*QtHeaders {
        name: "QtBootstrapHeaders"
        sync.module: "QtCore"
        profiles: project.hostProfile
        QtBootstrapHeaders { fileTags: "header_sync" }
    }*/

    QtHeaders {
        name: "QtConcurrentHeaders"
        sync.module: "QtConcurrent"
        sync.classNames: ({
            "qtconcurrentmap.h": ["QtConcurrentMap"],
            "qtconcurrentfilter.h": ["QtConcurrentFilter"],
            "qtconcurrentrun.h": ["QtConcurrentRun"],
        })
        QtConcurrentHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtCoreHeaders"
        sync.module: "QtCore"
        sync.classNames: ({
            "qglobal.h": ["QtGlobal"],
            "qendian.h": ["QtEndian"],
            "qconfig.h": ["QtConfig"],
            "qplugin.h": ["QtPlugin"],
            "qalgorithms.h": ["QtAlgorithms"],
            "qcontainerfwd.h": ["QtContainerFwd"],
            "qdebug.h": ["QtDebug"],
            "qevent.h": ["QtEvents"],
            "qnamespace.h": ["Qt"],
            "qnumeric.h": ["QtNumeric"],
            "qvariant.h": ["QVariantHash", "QVariantList", "QVariantMap"],
            "qbytearray.h": ["QByteArrayData"],
            "qbytearraylist.h": ["QByteArrayList"],
            /*"qgl.h": ["QGL"],
            "qsql.h": ["QSql"],
            "qssl.h": ["QSsl"],
            "qtest.h": ["QTest"],
            */
        })
        QtCoreHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtDBusHeaders"
        sync.module: "QtDBus"
        QtDBusHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtGuiHeaders"
        sync.module: "QtGui"
        QtGuiHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtNetworkHeaders"
        sync.module: "QtNetwork"
        QtNetworkHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtWidgetHeaders"
        sync.module: "QtWidgets"
        QtWidgetHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformHeaders"
        sync.module: "QtPlatformHeaders"
        QtPlatformHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtPlatformSupport"
        sync.module: "QtPlatformSupport"
        QtPlatformSupport { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQmlHeaders"
        sync.module: "QtQml"
        QtQmlHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQuickHeaders"
        sync.module: "QtQuick"
        QtQuickHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtMultimediaHeaders"
        sync.module: "QtMultimedia"
        QtMultimediaHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtMultimediaWidgetsHeaders"
        sync.module: "QtMultimediaWidgets"
        QtMultimediaWidgetsHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtSvgHeaders"
        sync.module: "QtSvg"
        QtSvgHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtTestHeaders"
        sync.module: "QtTest"
        QtTestHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtQuickTestHeaders"
        sync.module: "QtQuickTest"
        QtQuickTestHeaders { fileTags: "header_sync" }
    }

    QtHeaders {
        name: "QtXmlHeaders"
        sync.module: "QtXml"
        QtXmlHeaders { fileTags: "header_sync" }
    }
}
