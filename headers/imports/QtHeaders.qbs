import qbs

Product {
    type: "hpp"

    Depends { name: "cpp" }
    Depends { name: "QtHost.sync" }

    Group {
        fileTagsFilter: "hpp_public"
        qbs.install: true
        qbs.installDir: "include/" + QtHost.sync.module
    }

    Group {
        fileTagsFilter: "hpp_private"
        qbs.install: true
        qbs.installDir: "include/" + QtHost.sync.module + "/"
                        + project.qtVersion + "/" + QtHost.sync.module
                        + "/private"
    }

    Group {
        fileTagsFilter: "hpp_qpa"
        qbs.install: true
        qbs.installDir: "include/QtGui/" + project.qtVersion + "/QtGui/qpa"
    }
}
