import qbs

Product {
    type: "hpp"
    property string module
    sync.module: product.module

    Depends { name: "configure" }
    Depends { name: "sync" }

    Group {
        fileTagsFilter: ["hpp_public", "hpp_" + product.module]
        qbs.install: true
        qbs.installDir: "include/" + product.module
    }

    Group {
        fileTagsFilter: "hpp_private"
        qbs.install: true
        qbs.installDir: "include/" + product.module + "/"
                        + configure.version + "/" + product.module
                        + "/private"
    }

    Group {
        fileTagsFilter: "hpp_qpa"
        qbs.install: true
        qbs.installDir: "include/QtGui/" + configure.version + "/QtGui/qpa"
    }
}
