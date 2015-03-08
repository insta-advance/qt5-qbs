import qbs
import qbs.Probes

Probes.PkgConfigProbe {
    readonly property stringList libraryPaths: {
        var libraryPaths = [];
        if (found) {
            for (var i in libs) {
                if (libs[i].startsWith("-L"))
                    libraryPaths.push(libs[i].slice(2));
            }
        }
        return libraryPaths;
    }
    readonly property stringList dynamicLibraries: {
        var dynamicLibraries = [];
        if (found) {
            throw "here";
            for (var i in libs) {
                if (libs[i].startsWith("-l"))
                    dynamicLibraries.push(libs[i].slice(2));
            }
        }
        return dynamicLibraries;
    }
}
