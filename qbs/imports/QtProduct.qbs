import qbs

Product {
    readonly property path includeDirectory: project.buildDirectory + "/include"
    property stringList includeDependencies: []

    cpp.includePaths: {
        var includes = [
            includeDirectory,
            project.sourceDirectory + "/qtbase/mkspecs/" + project.target,
        ];
        for (var i in includeDependencies) {
            var module = includeDependencies[i];
            if (module.endsWith("-private")) {
                module = module.slice(0, -8);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module);
                includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                               + "/" + module + "/private");
                if (module == "QtGui") {
                    includes.push(includeDirectory + "/" + module + "/" + project.qtVersion
                                                   + "/" + module + "/qpa");
                }
            }
            includes.push(includeDirectory + "/" + module);
        }
        return includes;
    }

    Depends { name: "cpp" }
}
