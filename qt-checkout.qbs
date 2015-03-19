import qbs
import qbs.File
import qbs.Process

// This project acts as a repo tool, fetching all submodules defined in a JSON manifest
// usage exmamples:
//  qbs -f qt-checkout.qbs project.branch:dev
//  qbs -f qt-checkout.qbs project.branch:v5.5.0-alpha1
//  qbs -f qt-checkout.qbs project.modules:"qtbase,qtdeclarative,qtmultimedia"
Project {
    property string baseUrl: "https://github.com/qtproject/"
    property stringList modules: ["qtbase", "qttools", "qtdeclarative", "qtmultimedia"]
    property string branch: "v5.5.0-alpha1"

    Product {
        type: "git"
        Probe {
            configure: {
                var processes = [];
                for (var i in modules) {
                    var module = modules[i];
                    var process = new Process();
                    if (File.exists(module + "/.git")) {
                        print(module + " found. Checking out " + branch + "...");
                        process.needsCheckout = true;
                        process.setWorkingDirectory(module);
                        process.start("git", ["fetch", "origin"]);
                    } else {
                        print(module + " not found. Cloning " + baseUrl + module + ':' + branch + "...");
                        process.start("git", ["clone", baseUrl + modules[i], "-b", branch]);
                    }
                    processes.push(process);
                }
                for (var i in processes) {
                    var process = processes[i];
                    process.waitForFinished(60000);
                    print(process.readStdOut());
                    print(process.readStdErr());
                    if (process.needsCheckout) {
                        process.exec("git", ["checkout", branch]);
                        print(process.readStdOut());
                        print(process.readStdErr());
                    }
                    process.close();
                }
                found = true;
            }
        }
    }
}
