import qbs

Group {
    name: "headers"
    prefix: project.sourceDirectory + "/qtbase/src/platformsupport/"
    files: [
        "accessibility/*.h",
        "cfsocketnotifier/*.h",
        "cglconvenience/*.h",
        "clipboard/*.h",
        "dbusmenu/*.h",
        "dbustray/*.h",
        "devicediscovery/*.h",
        "eglconvenience/*.h",
        "eventdispatchers/*.h",
        "fbconvenience/*.h",
        "fontdatabases/basic/*.h",
        "fontdatabases/fontconfig/*.h",
        "fontdatabases/genericunix/*.h",
        "fontdatabases/mac/*.h",
        "glxconvenience/*.h",
        "input/evdevkeyboard/*.h",
        "input/evdevmouse/*.h",
        "input/evdevtablet/*.h",
        "input/evdevtouch/*.h",
        "input/libinput/*.h",
        "input/tslib/*.h",
        "linuxaccessibility/*.h",
        "platformcompositor/*.h",
        "services/genericunix/*.h",
        "themes/genericunix/*.h",
    ]
}
