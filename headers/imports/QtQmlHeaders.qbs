import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtdeclarative/src/qml/"
    files: [
        "animations/*.h",
        "compiler/*.h",
        //"debugger/*.h",
        "jit/*.h",
        "jsapi/*.h",
        "jsruntime/*.h",
        "parser/*.h",
        "qml/*.h",
        "types/*.h",
        "util/*.h",
    ]
}
