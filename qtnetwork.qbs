import qbs

QtModule {
    name: "QtNetwork"
    readonly property path basePath: project.sourceDirectory + "/qtbase/src/network/"

    Depends { name: "QtCore" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtNetworkHeaders" }
    Depends { name: "zlib" }

    cpp.defines: [
        "QT_BUILD_NETWORK_LIB",
    ].concat(base)

    cpp.dynamicLibraries: {
        var dynamicLibraries = [];
        if (qbs.targetOS.contains("windows") && !qbs.targetOS.contains("winrt")) {
            dynamicLibraries.push("advapi32");
            dynamicLibraries.push("dnsapi");
            dynamicLibraries.push("ws2_32");
        }
        if (project.libproxy) {
            dynamicLibraries.push("proxy");
        }
        return dynamicLibraries;
    }

    QtNetworkHeaders {
        excludeFiles: {
            var excludeFiles = ["doc/**"];
            if (!qbs.targetOS.contains("darwin")) {
                excludeFiles.push("access/qnetworkreplynsurlconnectionimpl_p.h");
            }
            if (!qbs.targetOS.contains("winrt")) {
                excludeFiles.push("socket/qnativesocketengine_winrt_p.h");
                excludeFiles.push("ssl/qsslsocket_winrt_p.h");
            }
            if (!project.openssl) {
                excludeFiles.push("ssl/qsslsocket_openssl_p.h");
            }
            return excludeFiles;
        }
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "access/qabstractnetworkcache.cpp",
            "access/qabstractprotocolhandler.cpp",
            "access/qftp.cpp",
            "access/qhttpmultipart.cpp",
            "access/qhttpnetworkconnection.cpp",
            "access/qhttpnetworkconnectionchannel.cpp",
            "access/qhttpnetworkheader.cpp",
            "access/qhttpnetworkreply.cpp",
            "access/qhttpnetworkrequest.cpp",
            "access/qhttpprotocolhandler.cpp",
            "access/qhttpthreaddelegate.cpp",
            "access/qnetworkaccessauthenticationmanager.cpp",
            "access/qnetworkaccessbackend.cpp",
            "access/qnetworkaccesscache.cpp",
            "access/qnetworkaccesscachebackend.cpp",
            "access/qnetworkaccessdebugpipebackend.cpp",
            "access/qnetworkaccessfilebackend.cpp",
            "access/qnetworkaccessftpbackend.cpp",
            "access/qnetworkaccessmanager.cpp",
            "access/qnetworkcookie.cpp",
            "access/qnetworkcookiejar.cpp",
            "access/qnetworkdiskcache.cpp",
            "access/qnetworkreply.cpp",
            "access/qnetworkreplydataimpl.cpp",
            "access/qnetworkreplyfileimpl.cpp",
            "access/qnetworkreplyhttpimpl.cpp",
            "access/qnetworkreplyimpl.cpp",
            "access/qnetworkrequest.cpp",
            "access/qspdyprotocolhandler.cpp",
            "bearer/qbearerengine.cpp",
            "bearer/qbearerplugin.cpp",
            "bearer/qnetworkconfigmanager.cpp",
            "bearer/qnetworkconfigmanager_p.cpp",
            "bearer/qnetworkconfiguration.cpp",
            "bearer/qnetworksession.cpp",
            "bearer/qsharednetworksession.cpp",
            "kernel/qauthenticator.cpp",
            "kernel/qdnslookup.cpp",
            "kernel/qhostaddress.cpp",
            "kernel/qhostinfo.cpp",
            "kernel/qnetworkinterface.cpp",
            "kernel/qnetworkproxy.cpp",
            "kernel/qurlinfo.cpp",
            "socket/qabstractsocket.cpp",
            "socket/qabstractsocketengine.cpp",
            "socket/qhttpsocketengine.cpp",
            "socket/qlocalserver.cpp",
            "socket/qlocalsocket.cpp",
            "socket/qnativesocketengine.cpp",
            "socket/qsocks5socketengine.cpp",
            "socket/qtcpserver.cpp",
            "socket/qtcpsocket.cpp",
            "socket/qudpsocket.cpp",
        ]
    }

    Group {
        name: "sources_android"
        condition: qbs.targetOS.contains("android")
        prefix: basePath
        files: [
            "kernel/qdnslookup_android.cpp",
        ]
    }

    Group {
        name: "sources_darwin"
        condition: qbs.targetOS.contains("darwin")
        prefix: basePath
        files: [
            "kernel/qnetworkproxy_mac.cpp",
            "ssl/qsslkey_mac.cpp",
            "ssl/qsslsocket_mac.cpp",
        ]
    }

    Group {
        name: "sources_unix"
        condition: qbs.targetOS.contains("unix")
        prefix: basePath
        files: [
            "kernel/qdnslookup_unix.cpp",
            "kernel/qhostinfo_unix.cpp",
            "kernel/qnetworkinterface_unix.cpp",
            "socket/qlocalserver_unix.cpp",
            "socket/qlocalsocket_unix.cpp",
            "socket/qnativesocketengine_unix.cpp",
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows") && !qbs.targetOS.contains("winrt")
        prefix: basePath
        files: [
            "kernel/qdnslookup_win.cpp",
            "kernel/qhostinfo_win.cpp",
            "kernel/qnetworkinterface_win.cpp",
            "kernel/qnetworkproxy_win.cpp",
            "socket/qlocalserver_win.cpp",
            "socket/qlocalsocket_win.cpp",
            "socket/qnativesocketengine_win.cpp",
        ]
    }

    Group {
        name: "sources_winrt"
        condition: qbs.targetOS.contains("winrt")
        prefix: basePath
        files: [
            "kernel/qdnslookup_winrt.cpp",
            "kernel/qhostinfo_winrt.cpp",
            "kernel/qnetworkinterface_winrt.cpp",
            "socket/qnativesocketengine_winrt.cpp",
            "ssl/qsslcertificate_winrt.cpp",
            "ssl/qsslkey_winrt.cpp",
            "ssl/qsslsocket_winrt.cpp",
        ]
    }

    Group {
        name: "sources_libproxy"
        condition: project.libproxy
        prefix: basePath
        files: [
            "kernel/qnetworkproxy_libproxy.cpp",
        ]
    }

    Group {
        name: "sources_ssl"
        condition: project.ssl
        prefix: basePath
        files: [
            "ssl/qasn1element.cpp",
            "ssl/qssl.cpp",
            "ssl/qsslcertificate.cpp",
            "ssl/qsslcertificateextension.cpp",
            "ssl/qsslcipher.cpp",
            "ssl/qsslconfiguration.cpp",
            "ssl/qsslellipticcurve.cpp",
            "ssl/qsslerror.cpp",
            "ssl/qsslkey_p.cpp",
            "ssl/qsslpresharedkeyauthenticator.cpp",
            "ssl/qsslsocket.cpp",
        ]
    }

    Group {
        name: "sources_openssl"
        condition: project.openssl
        prefix: basePath
        files: [
            "ssl/qsslcertificate_openssl.cpp",
            "ssl/qsslcontext_openssl.cpp",
            "ssl/qsslellipticcurve_openssl.cpp",
            "ssl/qsslkey_openssl.cpp",
            "ssl/qsslsocket_openssl.cpp",
            "ssl/qsslsocket_openssl_symbols.cpp",
        ]
    }

    Group {
        name: "sources_openssl_android"
        condition: project.openssl && qbs.targetOS.contains("android")
        prefix: basePath
        files: [
            "ssl/qsslsocket_openssl_android.cpp",
        ]
    }

    Group {
        name: "sources_qtssl"
        condition: project.ssl && !project.openssl
        files: [
            "ssl/qsslcertificate_qt.cpp",
            "ssl/qsslkey_qt.cpp",
        ]
    }
}
