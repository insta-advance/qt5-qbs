import qbs
import "QtUtils.js" as QtUtils

Project {
    id: root
    property string simpleName: ""
    property string moduleName: "Qt." + simpleName
    property string privateName: moduleName + "-private"
    property string headersName: name + "Headers"
    property string targetName: "Qt5" + name.slice(2)
    property string prefix
    property stringList defines: []
    property stringList includePaths: QtUtils.includesForModule(name + "-private", project.buildDirectory + "/include", project.version)
    property stringList publicIncludePaths: QtUtils.includesForModule(name, project.buildDirectory + "/include", project.version)
}
