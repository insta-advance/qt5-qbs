import qbs

QmlPlugin {
    name: "QtGraphicalEffects"
    pluginPath: "QtGraphicalEffects"
    type: "qml"

    Group {
        name: "qml"
        prefix: project.sourceDirectory + "/qtgraphicaleffects/src/effects/"
        files: [
            "qmldir",
            "Blend.qml",
            "BrightnessContrast.qml",
            "Colorize.qml",
            "ColorOverlay.qml",
            "ConicalGradient.qml",
            "Desaturate.qml",
            "DirectionalBlur.qml",
            "Displace.qml",
            "DropShadow.qml",
            "FastBlur.qml",
            "GammaAdjust.qml",
            "GaussianBlur.qml",
            "Glow.qml",
            "HueSaturation.qml",
            "InnerShadow.qml",
            "LevelAdjust.qml",
            "LinearGradient.qml",
            "MaskedBlur.qml",
            "OpacityMask.qml",
            "RadialBlur.qml",
            "RadialGradient.qml",
            "RectangularGlow.qml",
            "RecursiveBlur.qml",
            "ThresholdMask.qml",
            "ZoomBlur.qml",
        ]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath
    }

    Group {
        name: "qml_private"
        prefix: project.sourceDirectory + "/qtgraphicaleffects/src/effects/private/"
        files: [
            "FastGlow.qml",
            "FastInnerShadow.qml",
            "FastMaskedBlur.qml",
            "GaussianDirectionalBlur.qml",
            "GaussianGlow.qml",
            "GaussianInnerShadow.qml",
            "GaussianMaskedBlur.qml",
        ]
        qbs.install: true
        qbs.installDir: "qml/" + pluginPath + "/private"
    }
}
