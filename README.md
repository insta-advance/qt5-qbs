# Qt on QBS

## About the repository

This repository is designed as an alternative to the qt5.git(link) repository,
with a similar structure of submodules. Only those which have been ported to
QBS are contained here.

## About the project

This project explores the usefulness of building Qt(link) with QBS(link), with
the goal of creating faster base builds, faster iteration times when developing
Qt, benefiting from the improved developer experience Qt Creator provides when
using QBS, and to make porting to new platforms easier by bypassing the
traditional requirements of modifying configure/qmake.

The project is organized into to two parts: Qt host tools and the Qt libraries.
Qt host tools can be built once for the development environment, and need not
be rebuilt for each copy of Qt then compiled (as long as the version of Qt is
kept in sync between the host tools and the libraries). This has the
advantage that the host tools are not tied with any single target Qt build.

A command-line host tool, qhost(link), is used to emulate the query
functionality of qmake. This allows QBS to in turn use the Qt builds created by
this set of QBS files.

## Usage

This assumes you have a non-Qt profile(link) installed in your QBS settings.
This can be, for example, your system toolchain profile.

Prequisites are the same for Qt itself, except that Perl is not required.

### Build the host tools:
    qbs build -f qt-host-tools.qbs profile:<your host profile>

Install the host tools:
    qbs install -f qt-host-tools.qbs profile:<your host profile> --install-root /path/of/your/choice

You may, for example, install the tools to the local usr directory. This will
overwrite any existing tools in that directory, so use a subdirectory if you
want to manage multiple host tool versions.

### Build Qt
It is best to add the host tools' install-root bin directory to your PATH if
they are not already there. Check that e.g. qhost is available using:
    which qhost

Alternatively, on systems with qtchooser installed, you can set qhost as your
selected Qt version:
    qtchooser -install qhost <path-to-qhost>
    export QT_SELECT=qhost

Now, build Qt using your target profile:
    qbs build -f qt.qbs profile:<your target profile>

You may now install Qt:
    qbs install -f qt.qbs profile:<your target profile> --install-root /path/of/your/choice

### Configuring Qt
The previous instructions build Qt with default options, with some configuration
being detected based on availability of packages. For more fine-grained control,
set any of the following configuration options on the command line:

...

For example, to set the OpenGL configuration to "desktop", use:
    qbs build -f qt.qbs QtHost.config.opengl:desktop


### FAQ
Q: Does this project build qmake?
A: No, and we would like to keep it that way. If you are building Qt with QBS,
you should also be using it in your projects.
