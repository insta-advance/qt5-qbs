import qbs

PkgConfigDependency {
    condition: qbs.targetOS.contains("android") ? true : found
    name: "glesv2"
}
