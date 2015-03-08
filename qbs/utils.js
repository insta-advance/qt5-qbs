function libraryPaths(libs) {
    var libraryPaths = [];
    for (var i in libs) {
        if (libs[i].startsWith("-L"))
            libraryPaths.push(libs[i].slice(2));
    }
    return libraryPaths;
}

function dynamicLibraries(libs) {
    var dynamicLibraries = [];
    for (var i in libs) {
        if (libs[i].startsWith("-l"))
            dynamicLibraries.push(libs[i].slice(2));
    }
    return dynamicLibraries;
}
