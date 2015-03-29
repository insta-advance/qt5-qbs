function qtVersion(sourcePath)
{
    if (!File.exists(sourcePath + "/qtbase")) {
        throw "\nThe qtbase repository is required for detecting the Qt version. Please do one of the following:\n"
              + " - Specify project.sourcePath:<path to Qt sources> on the command line.\n"
              + " - Clone/unpack the qtbase repository into this directory.\n";
    }

    var version = "";
    var file = new TextFile(sourcePath + "/qtbase/src/corelib/global/qglobal.h");
    var reVersion = /#define QT_VERSION_STR +"(\d\.\d\.\d)"/;
    while (!file.atEof()) {
        var line = file.readLine();
        if (reVersion.test(line)) {
            version = line.match(reVersion)[1];
            break;
        }
    }
    file.close();

    if (!version.length)
        throw "Qt version not found.";

    return version;
}

function includesForModule(module, base, qtVersion) {
    var includes = [];
    if (module.endsWith("-private")) {
        module = module.slice(0, -8);
        includes.push(base + "/" + module + "/" + qtVersion);
        includes.push(base + "/" + module + "/" + qtVersion + "/" + module);
        includes.push(base + "/" + module + "/" + qtVersion + "/" + module + "/private");
        if (module == "QtGui")
            includes.push(base + "/" + module + "/" + qtVersion + "/" + module + "/qpa");
    }
    includes.push(base + '/' + module);
    return includes;
}

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
