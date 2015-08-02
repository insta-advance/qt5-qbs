import qbs
import "../../qbs/imports/QtUtils.js" as QtUtils

Product {
    type: "staticlibrary"

    profiles: project.targetProfiles

    Depends { name: "sync" }

    Group {
        fileTagsFilter: ["hpp_public", "hpp_" + sync.module]
        qbs.install: true
        qbs.installDir: sync.prefix + '/' + sync.module
    }

    Group {
        fileTagsFilter: "hpp_private"
        qbs.install: true
        qbs.installDir: sync.prefix + '/' + sync.module + "/"
                        + project.version + "/" + sync.module
                        + "/private"
    }

    Group {
        fileTagsFilter: "hpp_qpa"
        qbs.install: true
        qbs.installDir: sync.prefix + "/QtGui/" + project.version + "/QtGui/qpa"
    }
}
