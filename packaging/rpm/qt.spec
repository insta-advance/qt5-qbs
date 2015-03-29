Summary: Qt
Name: Qt
Version: %{qtversion}
Release: 1
License: LGPL2.1
Group: Frameworks
URL: https://github.com/intopalo/qt5-qbs
Vendor: Qt Project
Packager: Andrew Knight <andrew.knight@intopalo.com>
Source0: qt5-qbs.tar.gz
Source1: qtbase~v%{qtversion}%{qtsuffix}.tar.gz
Source2: qtdeclarative~v%{qtversion}%{qtsuffix}.tar.gz
Source3: qtmultimedia~v%{qtversion}%{qtsuffix}.tar.gz
Source4: qttools~v%{qtversion}%{qtsuffix}.tar.gz

%description
Qt is a cross-platform C++ application framework.
Qt's primary feature is its rich set of widgets that
provide standard GUI functionality.
This package was built using QBS, the Qt Build Suite.

%prep
%setup -n "qt5-qbs-master"
%setup -D -n "qt5-qbs-master" -a 1
mv "qtbase-%{qtversion}%{qtsuffix}" "qtbase"
%setup -D -n "qt5-qbs-master" -a 2
mv "qtdeclarative-%{qtversion}%{qtsuffix}" "qtdeclarative"
%setup -D -n "qt5-qbs-master" -a 3
mv "qtmultimedia-%{qtversion}%{qtsuffix}" "qtmultimedia"
%setup -D -n "qt5-qbs-master" -a 4
mv "qttools-%{qtversion}%{qtsuffix}" "qttools"

%build
qbs install -d %{_builddir} --install-root %{_builddir}/qt5-qbs-master \
    -f %{_builddir}/qt5-qbs-master/qt-configure.qbs %{args}
qbs build --no-install -f %{_builddir}/qt5-qbs-master/qt.qbs \
    configure.prefix:/opt/Qt/%{qtversion} %{args}

%install
qbs install --install-root %{_buildrootdir}/%{name}-%{version}-%{release}.%{_arch}/opt/Qt/%{qtversion} \
    -f %{_builddir}/qt5-qbs-master/qt.qbs %{args}

%files
/opt/Qt/%{qtversion}/bin/*
/opt/Qt/%{qtversion}/include/*
/opt/Qt/%{qtversion}/lib/*
/opt/Qt/%{qtversion}/mkspecs/*
/opt/Qt/%{qtversion}/plugins/*
/opt/Qt/%{qtversion}/qml/*
