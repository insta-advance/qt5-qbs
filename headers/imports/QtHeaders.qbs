import qbs
import "../../qbs/imports/QtUtils.js" as QtUtils

Product {
    type: "hpp"

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

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: QtUtils.includesForModule(sync.module + "-private",
                                                    project.buildDirectory + '/' + sync.prefix,
                                                    project.version)
    }
}
