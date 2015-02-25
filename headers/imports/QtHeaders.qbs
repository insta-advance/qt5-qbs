import qbs

Product {
    type: "hpp"

    Depends { name: "cpp" }
    Depends { name: "QtHost.sync" }
}
