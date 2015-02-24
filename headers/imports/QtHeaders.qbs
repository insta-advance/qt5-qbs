import qbs

Product {
    type: "hpp"

    Depends { name: "cpp" }
    Depends { name: "QtHost.sync" }
    QtHost.sync.module: product.name.endsWith("Headers")
                        ? product.name.slice(0, -7) : product.name
}
