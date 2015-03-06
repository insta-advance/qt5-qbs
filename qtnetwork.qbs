import qbs

QtModule {
    name: "QtNetwork"
    readonly property path basePath: project.sourceDirectory + "/qtbase/src/network"

    includeDependencies: ["QtCore", "QtCore-private", "QtNetwork", "QtNetwork-private"]

    cpp.defines: base.concat([
        "QT_BUILD_NETWORK_LIB",
        "QT_NO_SSL", // ### tie to QtHost.config
    ])

    Depends { name: "QtCore" }
    Depends { name: "QtNetworkHeaders" }
    Depends { name: "zlib" } // ### only spdy needs this

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: base.concat([
            "advapi32",
            "dnsapi",
            "ws2_32",
        ])
    }

    QtNetworkHeaders {
        excludeFiles: {
            var excludeFiles = [];

            if (!qbs.targetOS.contains("winrt"))
                excludeFiles.push("socket/qnativesocketengine_winrt_p.h");

            if (!qbs.targetOS.contains("osx"))
                excludeFiles.push("access/qnetworkreplynsurlconnectionimpl_p.h");

            if (!QtHost.config.spdy)
                excludeFiles.push("access/qspdyprotocolhandler*.h");

            if (!QtHost.config.ssl)
                excludeFiles.push("ssl/*.h");

            return excludeFiles;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "sources"
        prefix: basePath + "/"
        files: [
            "access/*.cpp",
            "bearer/*.cpp",
            "kernel/*.cpp",
            "socket/*.cpp",
        ]
        excludeFiles: {
            var excludeFiles = [];

            if (!qbs.targetOS.contains("android")) {
                excludeFiles.push("kernel/qdnslookup_android.cpp");
            }

            if (!qbs.targetOS.contains("blackberry")) {
                excludeFiles.push("kernel/qnetworkproxy_blackberry.cpp");
            }

            if (!qbs.targetOS.contains("osx")) {
                excludeFiles.push("kernel/qnetworkproxy_mac.cpp");
            }

            if (!qbs.targetOS.contains("unix")) {
                excludeFiles.push("kernel/qdnslookup_unix.cpp");
                excludeFiles.push("kernel/qhostinfo_unix.cpp");
                excludeFiles.push("kernel/qnetworkinterface_unix.cpp");
                excludeFiles.push("kernel/qnetworkproxy_generic.cpp");
            }

            if (!qbs.targetOS.contains("winrt")) {
                excludeFiles.push("kernel/qdnslookup_winrt.cpp");
                excludeFiles.push("kernel/qhostinfo_winrt.cpp");
                excludeFiles.push("kernel/qnetworkinterface_winrt.cpp");
                excludeFiles.push("socket/qnativesocketengine_winrt.cpp");
            }

            if (!qbs.targetOS.contains("windows")) {
                excludeFiles.push("kernel/qdnslookup_win.cpp");
                excludeFiles.push("kernel/qhostinfo_win.cpp");
                excludeFiles.push("kernel/qnetworkinterface_win.cpp");
                excludeFiles.push("kernel/qnetworkproxy_win.cpp");
                excludeFiles.push("socket/qlocalserver_win.cpp");
                excludeFiles.push("socket/qlocalsocket_win.cpp");
                excludeFiles.push("socket/qnativesocketengine_win.cpp");
            }

            if (!QtHost.config.localSocketTcp) {
                excludeFiles.push("socket/qlocalsocket_tcp.cpp");
                excludeFiles.push("socket/qlocalserver_tcp.cpp");
            }

            if (!QtHost.config.libProxy) {
                excludeFiles.push("kernel/qnetworkproxy_libproxy.cpp");
            }

            return excludeFiles;
        }
        fileTags: "moc"
        overrideTags: false
    }

    Group {
        name: "ssl"
        prefix: basePath + "/ssl/"
        condition: QtHost.config.ssl
        files: [
            "*.cpp",
        ]
    }
}
