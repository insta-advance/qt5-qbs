function qtVersion(sourcePath)
{
    if (!File.exists(sourcePath + "/qtbase")) {
        throw "The qtbase repository is required for detecting the Qt version. Please do one of the following:\n"
              + " - Specify project.sourcePath:<path to Qt sources> on the command line.\n"
              + " - Set an environment variable named QT_SOURCE containing the path to your Qt sources.\n"
              + " - Clone/unpack the qtbase repository into the qt5-qbs directory.\n";
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

function detectTargetMkspec(targetOS, toolchain, architecture)
{
    if (targetOS.contains("linux")) {
        if (toolchain.contains("clang"))
            return "linux-clang";
        else if (toolchain.contains("gcc"))
            return "linux-g++";
    } else if (targetOS.contains("winphone")) {
        switch (architecture) {
        case "x86":
            return "winphone-x86-msvc2013";
        case "x86_64":
            return "winphone-x64-msvc2013";
        case "arm":
            return "winphone-arm-msvc2013";
        }
    } else if (targetOS.contains("winrt")) {
        switch (architecture) {
        case "x86":
            return "winrt-x86-msvc2013";
        case "x86_64":
            return "winrt-x64-msvc2013";
        case "arm":
            return "winrt-arm-msvc2013";
        }
    } else if (targetOS.contains("windows")) {
        if (toolchain.contains("mingw"))
            return "win32-g++";
        else if (toolchain.contains("msvc"))
            return "win32-msvc2013";
    }
    return "";
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
