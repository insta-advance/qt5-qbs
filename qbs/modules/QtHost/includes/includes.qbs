import qbs 1.0

// ### consider merging this with the respective headers items
// ### or, it could be exported from Qt a modules (better)
Module {
    property path includeDirectory: project.buildDirectory + "/include"
    property stringList modules: []
    readonly property stringList modulesIncludes: {
        var includes = [
            includeDirectory,
            project.sourceDirectory + "/qtbase/mkspecs/" + project.target,
        ];
        var moduleMap = {
            core: "QtCore",
            gui: "QtGui",
            platformheaders: "QtPlatformHeaders",
            platformsupport: "QtPlatformSupport",
        };
        for (var i in modules) {
            var baseName = modules[i];
            var isPrivate = baseName.endsWith("-private");
            if (isPrivate)
                baseName = baseName.slice(0, -8);

            var module = moduleMap[baseName];
            if (!module)
                module = "Qt" + baseName[0].toUpperCase() + baseName.slice(1);

            includes.push(includeDirectory + "/" + module);
            if (isPrivate) {
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module + "/private");
                if (baseName == "gui") {
                    includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                                   + "/" + module + "/qpa");
                }
            }
        }
        return includes;
    }

    Depends { name: "cpp" }
    cpp.includePaths: base.concat(modulesIncludes)

    Depends { name: "QtHost.moc" }
    QtHost.moc.includePaths: base.concat(modulesIncludes)
}
