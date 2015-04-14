import qbs

Project {
    name: "QtNetwork"
    QtModule {
        name: "QtNetwork"
        condition: configure.network !== false

        readonly property path basePath: project.sourcePath + "/qtbase/src/network"

        includeDependencies: ["QtCore-private", "QtNetwork", "QtNetwork-private"]

        cpp.defines: {
            var defines = base;

            defines.push("QT_BUILD_NETWORK_LIB");

            if (!configure.ssl)
                defines.push("QT_NO_SSL");

            return defines;
        }

        Depends { name: "QtCore" }
        Depends { name: "QtNetworkHeaders" }
        Depends { name: "zlib" } // ### only spdy needs this

        Properties {
            condition: qbs.targetOS.contains("windows")
            cpp.dynamicLibraries: [
                "advapi32",
                "dnsapi",
                "ws2_32",
            ].concat(outer)
        }

        QtNetworkHeaders {
            excludeFiles: {
                var excludeFiles = ["doc/**"];

                if (!qbs.targetOS.contains("winrt"))
                    excludeFiles.push("socket/qnativesocketengine_winrt_p.h");

                if (!qbs.targetOS.contains("osx"))
                    excludeFiles.push("access/qnetworkreplynsurlconnectionimpl_p.h");

                if (!configure.spdy)
                    excludeFiles.push("access/qspdyprotocolhandler*.h");

                if (!configure.ssl)
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
                "ssl/*.cpp",
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
                    excludeFiles.push("socket/qlocalserver_unix.cpp");
                    excludeFiles.push("socket/qlocalsocket_unix.cpp");
                    excludeFiles.push("socket/qnativesocketengine_unix.cpp");
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

                if (!configure.localSocketTcp) {
                    excludeFiles.push("socket/qlocalsocket_tcp.cpp");
                    excludeFiles.push("socket/qlocalserver_tcp.cpp");
                }

                if (!configure.libProxy) {
                    excludeFiles.push("kernel/qnetworkproxy_libproxy.cpp");
                }

                if (!configure.ssl) {
                    excludeFiles.push("ssl/*.cpp");
                }

                return excludeFiles;
            }
            fileTags: "moc"
            overrideTags: false
        }
    }
}
