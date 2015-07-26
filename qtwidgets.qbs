import qbs

QtModule {
    name: "QtWidgets"
    condition: project.widgets

    readonly property path basePath: project.sourceDirectory + "/qtbase/src/widgets/"

    Depends { name: "uic"; profiles: project.hostProfile }
    Depends { name: "gl"; condition: project.opengl }
    Depends { name: "gtk+"; condition: project.gtkstyle }
    Depends { name: "x11"; condition: project.gtkstyle }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtWidgetHeaders" }

    cpp.defines: [
        "QT_BUILD_WIDGETS_LIB",
        "QT_NO_STYLE_MAC", // ### fixme: put these inside Properties
        "QT_NO_STYLE_WINDOWS",
        "QT_NO_STYLE_WINDOWSVISTA",
        "QT_NO_STYLE_WINDOWSXP",
        "QT_NO_STYLE_ANDROID",
    ].concat(base)

    cpp.dynamicLibraries: {
        var dynamicLibraries = base;
        if (qbs.targetOS.contains("windows")) {
            dynamicLibraries.push("gdi32");
            dynamicLibraries.push("shell32");
            dynamicLibraries.push("user32");
        }
        return dynamicLibraries;
    }

    QtWidgetHeaders {
        name: "headers"
        excludeFiles: {
            var excludeFiles = ["doc/**"];
            // ### fixme: these probably just need QT_NO_STYLE_XXX
            if (!qbs.targetOS.contains("osx")) {
                excludeFiles.push("widgets/qmaccocoaviewcontainer_mac.h");
                excludeFiles.push("widgets/qmacnativewidget_mac.h");
            }
            return excludeFiles;
        }
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "accessible/complexwidgets.cpp",
            "accessible/itemviews.cpp",
            "accessible/qaccessiblemenu.cpp",
            "accessible/qaccessiblewidget.cpp",
            "accessible/qaccessiblewidgetfactory.cpp",
            "accessible/qaccessiblewidgets.cpp",
            "accessible/rangecontrols.cpp",
            "accessible/simplewidgets.cpp",
            "dialogs/qcolordialog.cpp",
            "dialogs/qdialog.cpp",
            "dialogs/qerrormessage.cpp",
            "dialogs/qfiledialog.cpp",
            "dialogs/qfileinfogatherer.cpp",
            "dialogs/qfilesystemmodel.cpp",
            "dialogs/qfontdialog.cpp",
            "dialogs/qinputdialog.cpp",
            "dialogs/qmessagebox.cpp",
            "dialogs/qprogressdialog.cpp",
            "dialogs/qsidebar.cpp",
            "dialogs/qwizard.cpp",
            "dialogs/qwizard_win.cpp",
            "dialogs/qmessagebox.qrc",
            "dialogs/qfiledialog.ui",
            "dialogs/qfiledialog_embedded.ui",
            "effects/qgraphicseffect.cpp",
            "effects/qpixmapfilter.cpp",
            "graphicsview/qgraphicsanchorlayout.cpp",
            "graphicsview/qgraphicsanchorlayout_p.cpp",
            "graphicsview/qgraphicsgridlayout.cpp",
            "graphicsview/qgraphicsgridlayoutengine.cpp",
            "graphicsview/qgraphicsitem.cpp",
            "graphicsview/qgraphicsitemanimation.cpp",
            "graphicsview/qgraphicslayout.cpp",
            "graphicsview/qgraphicslayoutitem.cpp",
            "graphicsview/qgraphicslayout_p.cpp",
            "graphicsview/qgraphicslayoutstyleinfo.cpp",
            "graphicsview/qgraphicslinearlayout.cpp",
            "graphicsview/qgraphicsproxywidget.cpp",
            "graphicsview/qgraphicsscene.cpp",
            "graphicsview/qgraphicsscene_bsp.cpp",
            "graphicsview/qgraphicsscenebsptreeindex.cpp",
            "graphicsview/qgraphicssceneevent.cpp",
            "graphicsview/qgraphicssceneindex.cpp",
            "graphicsview/qgraphicsscenelinearindex.cpp",
            "graphicsview/qgraphicstransform.cpp",
            "graphicsview/qgraphicsview.cpp",
            "graphicsview/qgraphicswidget.cpp",
            "graphicsview/qgraphicswidget_p.cpp",
            "graphicsview/qsimplex_p.cpp",
            "itemviews/qabstractitemdelegate.cpp",
            "itemviews/qabstractitemview.cpp",
            "itemviews/qbsptree.cpp",
            "itemviews/qcolumnview.cpp",
            "itemviews/qcolumnviewgrip.cpp",
            "itemviews/qdatawidgetmapper.cpp",
            "itemviews/qdirmodel.cpp",
            "itemviews/qfileiconprovider.cpp",
            "itemviews/qheaderview.cpp",
            "itemviews/qitemdelegate.cpp",
            "itemviews/qitemeditorfactory.cpp",
            "itemviews/qlistview.cpp",
            "itemviews/qlistwidget.cpp",
            "itemviews/qstyleditemdelegate.cpp",
            "itemviews/qtableview.cpp",
            "itemviews/qtablewidget.cpp",
            "itemviews/qtreeview.cpp",
            "itemviews/qtreewidget.cpp",
            "itemviews/qtreewidgetitemiterator.cpp",
            "kernel/qaction.cpp",
            "kernel/qactiongroup.cpp",
            "kernel/qapplication.cpp",
            "kernel/qboxlayout.cpp",
            "kernel/qdesktopwidget.cpp",
            "kernel/qformlayout.cpp",
            "kernel/qgesture.cpp",
            "kernel/qgesturemanager.cpp",
            "kernel/qgesturerecognizer.cpp",
            "kernel/qgridlayout.cpp",
            "kernel/qlayout.cpp",
            "kernel/qlayoutengine.cpp",
            "kernel/qlayoutitem.cpp",
            "kernel/qmacgesturerecognizer.cpp",
            "kernel/qopenglwidget.cpp",
            "kernel/qshortcut.cpp",
            "kernel/qsizepolicy.cpp",
            "kernel/qstackedlayout.cpp",
            "kernel/qstandardgestures.cpp",
            "kernel/qtooltip.cpp",
            "kernel/qwhatsthis.cpp",
            "kernel/qwidget.cpp",
            "kernel/qwidgetaction.cpp",
            "kernel/qwidgetbackingstore.cpp",
            //"kernel/qwidgetsfunctions_wince.cpp",
            "kernel/qwidgetsvariant.cpp",
            "kernel/qwidgetwindow.cpp",
            "kernel/qwindowcontainer.cpp",
            "statemachine/qbasickeyeventtransition.cpp",
            "statemachine/qbasicmouseeventtransition.cpp",
            "statemachine/qguistatemachine.cpp",
            "statemachine/qkeyeventtransition.cpp",
            "statemachine/qmouseeventtransition.cpp",
            "styles/qandroidstyle.cpp",
            "styles/qcommonstyle.cpp",
            "styles/qdrawutil.cpp",
            "styles/qfusionstyle.cpp",
            "styles/qgtk2painter.cpp",
            "styles/qgtkpainter.cpp",
            "styles/qgtkstyle.cpp",
            "styles/qgtkstyle_p.cpp",
            "styles/qproxystyle.cpp",
            "styles/qstyle.cpp",
            "styles/qstyleanimation.cpp",
            "styles/qstylefactory.cpp",
            "styles/qstylehelper.cpp",
            "styles/qstyleoption.cpp",
            "styles/qstylepainter.cpp",
            "styles/qstyleplugin.cpp",
            "styles/qstylesheetstyle.cpp",
            "styles/qstylesheetstyle_default.cpp",
            "styles/qwindowscestyle.cpp",
            "styles/qwindowsmobilestyle.cpp",
            "styles/qwindowsstyle.cpp",
            "styles/qwindowsvistastyle.cpp",
            "styles/qwindowsxpstyle.cpp",
            "styles/qstyle.qrc",
            "util/qcolormap.cpp",
            "util/qcompleter.cpp",
            "util/qflickgesture.cpp",
            "util/qscroller.cpp",
            "util/qscrollerproperties.cpp",
            "util/qsystemtrayicon.cpp",
            //"util/qsystemtrayicon_qpa.cpp",
            //"util/qsystemtrayicon_win.cpp",
            //"util/qsystemtrayicon_wince.cpp",
            "util/qsystemtrayicon_x11.cpp",
            "util/qundogroup.cpp",
            "util/qundostack.cpp",
            "util/qundoview.cpp",
            "widgets/qabstractbutton.cpp",
            "widgets/qabstractscrollarea.cpp",
            "widgets/qabstractslider.cpp",
            "widgets/qabstractspinbox.cpp",
            "widgets/qbuttongroup.cpp",
            "widgets/qcalendarwidget.cpp",
            "widgets/qcheckbox.cpp",
            "widgets/qcombobox.cpp",
            "widgets/qcommandlinkbutton.cpp",
            "widgets/qdatetimeedit.cpp",
            "widgets/qdial.cpp",
            "widgets/qdialogbuttonbox.cpp",
            "widgets/qdockarealayout.cpp",
            "widgets/qdockwidget.cpp",
            "widgets/qeffects.cpp",
            "widgets/qfocusframe.cpp",
            "widgets/qfontcombobox.cpp",
            "widgets/qframe.cpp",
            "widgets/qgroupbox.cpp",
            "widgets/qkeysequenceedit.cpp",
            "widgets/qlabel.cpp",
            "widgets/qlcdnumber.cpp",
            "widgets/qlineedit.cpp",
            "widgets/qlineedit_p.cpp",
            "widgets/qmainwindow.cpp",
            "widgets/qmainwindowlayout.cpp",
            "widgets/qmdiarea.cpp",
            "widgets/qmdisubwindow.cpp",
            "widgets/qmenu.cpp",
            "widgets/qmenubar.cpp",
            //"widgets/qmenu_wince.cpp",
            "widgets/qplaintextedit.cpp",
            "widgets/qprogressbar.cpp",
            "widgets/qpushbutton.cpp",
            "widgets/qradiobutton.cpp",
            "widgets/qrubberband.cpp",
            "widgets/qscrollarea.cpp",
            "widgets/qscrollbar.cpp",
            "widgets/qsizegrip.cpp",
            "widgets/qslider.cpp",
            "widgets/qspinbox.cpp",
            "widgets/qsplashscreen.cpp",
            "widgets/qsplitter.cpp",
            "widgets/qstackedwidget.cpp",
            "widgets/qstatusbar.cpp",
            "widgets/qtabbar.cpp",
            "widgets/qtabwidget.cpp",
            "widgets/qtextbrowser.cpp",
            "widgets/qtextedit.cpp",
            "widgets/qtoolbar.cpp",
            "widgets/qtoolbararealayout.cpp",
            "widgets/qtoolbarextension.cpp",
            "widgets/qtoolbarlayout.cpp",
            "widgets/qtoolbarseparator.cpp",
            "widgets/qtoolbox.cpp",
            "widgets/qtoolbutton.cpp",
            "widgets/qwidgetanimator.cpp",
            "widgets/qwidgetlinecontrol.cpp",
            "widgets/qwidgetresizehandler.cpp",
            "widgets/qwidgettextcontrol.cpp",
        ]
    }
}
