import qbs

// Base type for QtModule and QtPlugin
QtProduct {
    type: "dynamiclibrary" // ### food for thought: delay linking for another step, making headers the only dependency

    cpp.defines: base.concat([
        "QT_BUILDING_QT",
        "_USE_MATH_DEFINES",
        "QT_ASCII_CAST_WARNINGS",
        "QT_MOC_COMPAT",
        "QT_DEPRECATED_WARNINGS",
        "QT_DISABLE_DEPRECATED_BEFORE=0x040800",
    ])

    cpp.includePaths: base.concat([
        product.buildDirectory + "/.moc",
    ])

    Depends { name: "cpp" }
    Depends { name: "QtHost"; submodules: ["rcc"] }
}
