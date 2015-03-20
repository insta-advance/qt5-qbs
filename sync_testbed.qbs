import qbs

Product {
    type: "hpp"

    Depends { name: "sync" }
    sync.module: "QtNetwork"

    Group {
        name: "header_sync"
        fileTags: "header_sync"
        prefix: project.sourcePath + "/qtbase/src/"
        files: "network/access/qnetworkaccessmanager.h"
    }
}
