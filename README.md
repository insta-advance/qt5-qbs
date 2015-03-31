# Qt on QBS

## About the project

This project explores the usefulness of building Qt using QBS(link), with
the goal of creating faster base builds, faster iteration times when developing
Qt, benefiting from the improved developer experience Qt Creator provides when
using QBS, and to make porting to new platforms easier by bypassing the
traditional requirements of modifying configure/qmake.

The project is organized into to two parts: Qt host tools and the Qt libraries.
Qt host tools can be built once for the development environment, and need not
be rebuilt for each copy of Qt then compiled (as long as the version of Qt is
kept in sync between the host tools and the libraries). This has the
advantage that the host tools are not tied with any single target Qt build.

A command-line host tool, qhost, is used to emulate the query
functionality of qmake. This allows QBS to in turn use the Qt builds created by
this set of QBS files.

*QBS >=1.4.0 is required.*

## Usage

This assumes you have a non-Qt profile installed in your QBS settings.
This can be, for example, your system toolchain profile.

Prequisites are the same for Qt itself, except that Perl is not required.

### Build the host tools:

    qbs build -f qt-host-tools.qbs project.sourcePath:<path to qt sources> qbs.installRoot:<somewhere to install the tools> profile:<your host profile>

You may, for example, install the tools to the local usr directory. This will
overwrite any existing tools in that directory, so use a subdirectory if you
want to manage multiple host tool versions.

### Configure Qt
To reduce the overhead of repeatedly evaluating probes between builds, a
separate configuration project is used. This will create a JSON file
auto-detected configuration options. Feel free to edit this file
and save it for later. You can rename the file to qtconfig.json, but it is
recommended that you place it in a specific directory (for example, your HOME
directory), and pass this file to QBS when building Qt.

    qbs build -f qt-configure.qbs

You can save this to your profile by executing

    cp <profile>-<buildVariant>/qtconfig.json ~/qtconfig-<profile>.json
    qbs-config <profile>.qbs.qtconfig ~/qtconfig-<profile>.json

### Build Qt
It is best to add the host tools' install-root bin directory to your PATH if
they are not already there. Check that e.g. qhost is available using:
    which qhost

Alternatively, on systems with qtchooser installed, you can set qhost as your
selected Qt version:

    qtchooser -install qhost <path-to-qhost>
    export QT_SELECT=qhost

Now, build Qt using your configuration and target profile:

    qbs build -f qt.qbs profile:<your target profile> qbs.installRoot:/path/of/your/choice

*Note*: remember to also pass `configure.configuration:<path to qconfig.json>` if
you did not set a default configuration or add a qconfig.json to your source directory.
Or you can pass `configure.configuration:null` to disable loading from a configuration file.

You may also pass configuration arguments on the command line, for example:

    qbs [...] configure.opengl:"desktop" # enables desktop OpenGL
    qbs [...] configure.widgets: false   # disables widgets

Alternatively, install Qt as a separate step by adding --no-install to the build method above and then running:
    qbs install -f qt.qbs profile:<your target profile> --install-root /path/of/your/choice

### FAQ

Q: Does this project build qmake?

A: No, and we would like to keep it that way. If you are building Qt with QBS,
you should also be using it in your projects.
