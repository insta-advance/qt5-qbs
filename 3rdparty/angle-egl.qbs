import qbs

DynamicLibrary {
    targetName: "EGL"
    type: "dynamiclibrary"
    builtByDefault: false
    condition: configure.angle

    readonly property path basePath: project.sourcePath + "/qtbase/src/3rdparty/angle"

    cpp.dynamicLibraryPrefix: "lib"

    cpp.defines: [
        "GL_APICALL=",
        "GL_GLEXT_PROTOTYPES=",
        "EGLAPI=",
        "LIBEGL_IMPLEMENTATION",
    ].concat(base)

    cpp.includePaths: [
        basePath + "/include",
        basePath + "/src",
    ].concat(base)

    Depends { name: "configure" }
    Depends { name: "cpp" }
    Depends { name: "angle-glesv2" }

    Properties {
        condition: qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: [
            "pthread",
        ].concat(outer)
    }

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cxxFlags: [
            "-std=c++11",
        ].concat(outer)
    }

    Group {
        name: "source"
        prefix: basePath + "/src/libEGL/"
        files: {
            var files = [
                        "*.cpp",
                    ];
            if (qbs.targetOS.contains("windows")) {
                files.push("renderer/d3d/*.cpp");
                files.push("renderer/d3d/d3d11/*.cpp");
                if (!qbs.targetOS.contains("winrt"))
                    files.push("renderer/d3d/d3d9/*.cpp");
            }
            return files;
        }
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourcePath + "/qtbase/src/3rdparty/angle/include"
    }
}
