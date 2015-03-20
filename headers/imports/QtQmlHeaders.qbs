import qbs

Group {
    name: "headers"
    prefix: project.sourcePath + "/qtdeclarative/src/qml/"
    files: [
        "*.h",
        "animations/*.h",
        "compiler/*.h",
        "debugger/*.h",
        "jit/*.h",
        "jsapi/*.h",
        "jsruntime/*.h",
        "parser/*.h",
        "qml/*.h",
        "qml/ftw/*.h",
        "qml/v8/*.h",
        "types/*.h",
        "util/*.h",
    ]
}
