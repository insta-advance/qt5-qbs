import qbs

DynamicLibrary {
    targetName: "GLESv2"
    type: "dynamiclibrary"
    builtByDefault: false

    cpp.dynamicLibraryPrefix: "lib"

    readonly property path basePath: project.sourcePath + "/qtbase/src/3rdparty/angle"
    readonly property stringList cppDefines: [
        "ANGLE_TRANSLATOR_STATIC",
        "LIBANGLE_IMPLEMENTATION",
        "LIBGLESV2_IMPLEMENTATION",
        'GL_APICALL=',
        'GL_GLEXT_PROTOTYPES=',
        'EGLAPI=',
        'ANGLE_PRELOADED_D3DCOMPILER_MODULE_NAMES={ "d3dcompiler_47.dll", "d3dcompiler_46.dll", "d3dcompiler_43.dll" }',
        "ANGLE_MULTITHREADED_D3D_SHADER_COMPILE=0", // ### mingw/msvc2010 only
        "ANGLE_SKIP_DXGI_1_2_CHECK",
        "NDEBUG", //### fix the ID3DDebug usage instead
        "D3DCOMPILE_RESERVED16=0x00010000", // ### mingw
        "D3DCOMPILE_RESERVED17=0x00020000", // ### mingw
        "D3D11_MAP_FLAG_DO_NOT_WAIT=0x1000000", // ### mingw
    ];

    cpp.defines: cppDefines

    cpp.includePaths: [
        basePath + "/include",
        basePath + "/src",
        basePath + "/src/third_party/khronos/",
        basePath + "/src/compiler/preprocessor",
        project.sourceDirectory + "/include/angle/" + project.qtVersion,
    ].concat(base)

    Depends { name: "configure" }
    Depends { name: "cpp" }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.defines: [
            "_WIN32",
            "NOMINMAX=1",
            "ANGLE_ENABLE_HLSL",
            "ANGLE_ENABLE_D3D9",
            "ANGLE_ENABLE_D3D11",
        ].concat(cppDefines)
        cpp.dynamicLibraries: [
            "d3d9",
            "dxguid",
            "gdi32",
            "user32",
        ]
        cpp.linkerFlags: {
            var linkerFlags = base;
            var def =  basePath + "/src/libGLESv2/libGLESv2"
                    + (qbs.buildVariant == "debug" ? "d" : "");
            if (qbs.toolchain.contains("msvc")) {
                linkerFlags.push("/DEF:" + def + ".def");
            } else if (qbs.toolchain.contains("mingw")) {
                linkerFlags.push("-Wl," + def + ".def");
                //linkerFlags.push("-Wl," + def + "_mingw.def");
            }
            return linkerFlags;
        }
    }

    Properties {
        condition: qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: base.concat("pthread")
    }

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.cxxFlags: [
            "-std=c++11",
            "-Wno-unused-parameter",
        ]
    }

    Group {
        name: "QtANGLEHeaders"
        files: [
            project.sourcePath + "/qtbase/src/3rdparty/angle/include/EGL",
            project.sourcePath + "/qtbase/src/3rdparty/angle/include/GLES2",
            project.sourcePath + "/qtbase/src/3rdparty/angle/include/GLES3",
            project.sourcePath + "/qtbase/src/3rdparty/angle/include/KHR",
        ]
        fileTags: "hpp_ANGLE"
        qbs.install: true
        qbs.installDir: "include/QtANGLE"
    }

    Group {
        name: "headers"
        prefix: basePath + "/src/"
        files: [
            "common/*.h",
            "compiler/preprocessor/*.h",
            "compiler/translator/*.h",
            "compiler/translator/depgraph/*.h",
            "compiler/translator/timing/*.h",
            "libANGLE/*.h",
            "libANGLE/renderer/*.h",
            "libANGLE/renderer/d3d/*.h",
            "libANGLE/renderer/d3d/d3d9/*.h",
            "libANGLE/renderer/d3d/d3d11/*.h",
            "libANGLE/renderer/d3d/d3d11/win32/*.h",
            "libANGLE/renderer/d3d/d3d11/winrt/*.h",
            "libGLESv2/*.h",
            "third_party/*.h",
            "third_party/compiler/*.h",
            "third_party/murmurhash/*.h",
            "third_party/systeminfo/*.h",
        ]
    }

    Group {
        name: "source"
        prefix: basePath + "/src/"
        files: {
            var files = [
                        "common/*.cpp",
                        "compiler/preprocessor/*.cpp",
                        "compiler/translator/*.cpp",
                        "compiler/translator/depgraph/*.cpp",
                        "compiler/translator/timing/*.cpp",
                        "libANGLE/*.cpp",
                        "libANGLE/renderer/*.cpp",
                        "libGLESv2/*.cpp",
                        "third_party/compiler/ArrayBoundsClamper.cpp",
                    ];
            if (qbs.targetOS.contains("windows")) {
                files.push("libANGLE/renderer/d3d/*.cpp");
                files.push("libANGLE/renderer/d3d/d3d11/*.cpp");
                files.push("third_party/systeminfo/SystemInfo.cpp");
                files.push("third_party/murmurhash/MurmurHash3.cpp");
                if (qbs.targetOS.contains("winrt")) {
                    files.push("libANGLE/renderer/d3d/d3d11/winrt/*.cpp");
                } else {
                    files.push("libANGLE/renderer/d3d/d3d9/*.cpp");
                    files.push("libANGLE/renderer/d3d/d3d11/win32/*.cpp");
                }
            }
            return files;
        }
    }

    Group {
        name: "flex"
        prefix: basePath + "/src/compiler/"
        files: [
            "preprocessor/Tokenizer.l",
            "translator/glslang.l",
        ]
        fileTags: "flex"
    }

    Rule {
        inputs: "flex"
        Artifact {
            filePath: input.baseName + "_lex.cpp"
            fileTags: "cpp"
        }
        prepare: {
            var cmdName = product.moduleProperty("qbs", "hostOS").contains("windows") ? "win_flex" : "flex";
            var cmd = new Command(cmdName, [
                                      "--noline", "--nounistd",
                                      "--outfile=" + output.filePath, input.filePath,
                                  ]);
            cmd.description = "flex " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }

    Group {
        name: "bison"
        prefix: basePath + "/src/compiler/"
        files: [
            "preprocessor/ExpressionParser.y",
            "translator/glslang.y",
        ]
        fileTags: "bison"
    }

    Rule {
        inputs: "bison"
        Artifact {
            filePath: input.baseName + "_tab.h"
            fileTags: "hpp"
        }
        Artifact {
            filePath: input.baseName + "_tab.cpp"
            fileTags: "cpp"
        }
        prepare: {
            var cmdName = product.moduleProperty("qbs", "hostOS").contains("windows") ? "win_bison" : "bison";
            var cmd = new Command(cmdName, [
                                      "--no-lines", "--skeleton=yacc.c",
                                      "--defines=" + outputs.hpp[0].filePath,
                                      "--output=" + outputs.cpp[0].filePath,
                                      input.filePath,
                                  ]);
            cmd.description = "bison " + input.fileName;
            cmd.highlight = "codegen";
            return cmd;
        }
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: project.sourcePath + "/qtbase/src/3rdparty/angle/include"
    }
}
