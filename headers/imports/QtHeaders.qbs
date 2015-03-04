import qbs

Product {
    type: "hpp"
    property string module
    QtHost.sync.module: product.module

    Depends { name: "QtHost.sync" }

    Group {
        fileTagsFilter: "hpp_public"
        qbs.install: true
        qbs.installDir: "include/" + product.module
    }

    Group {
        fileTagsFilter: "hpp_private"
        qbs.install: true
        qbs.installDir: "include/" + product.module + "/"
                        + project.qtVersion + "/" + product.module
                        + "/private"
    }

    Group {
        fileTagsFilter: "hpp_qpa"
        qbs.install: true
        qbs.installDir: "include/QtGui/" + project.qtVersion + "/QtGui/qpa"
    }
}
