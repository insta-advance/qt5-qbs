import qbs
import qbs.File

QtModule {
    name: "QtGui"
    property path basePath: project.sourceDirectory + "/qtbase/src/gui"

    Depends { name: "QtGuiHeaders" }
    Depends { name: "zlib" }
    Depends { name: "jpeg" }
    Depends { name: "png" }
    Depends { name: "freetype" }
    Depends { name: "QtCore" }
    QtHost.includes.modules: ["gui", "gui-private"]

    cpp.defines: base.concat([
        "QT_BUILD_GUI_LIB",
    ])

    Properties {
        condition: QtHost.config.opengl == "desktop" && qbs.targetOS.contains("unix")
        cpp.dynamicLibraries: base.concat([
            "GL",
        ])
    }

    Properties {
        condition: QtHost.config.opengl == "es2"
        cpp.dynamicLibraries: base.concat([
            "GLESv2",
        ])
    }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: base.concat([
            "opengl32",
            "user32",
            "gdi32",
        ])
    }

    Group {
        id: headers_moc_p
        name: "headers (delayed moc)"
        prefix: basePath + "/"
        fileTags: "moc_hpp_p"
        files: [
            "image/qmovie.h",
            "itemmodels/qstandarditemmodel.h",
            "kernel/qguiapplication.h",
            "kernel/qinputmethod.h",
            "kernel/qwindow.h",
            "kernel/qplatformsystemtrayicon.h",
            "opengl/qopengldebug.h",
            "opengl/qopenglvertexarrayobject.h",
            "text/qabstracttextdocumentlayout.h",
            "text/qsyntaxhighlighter.h",
            "text/qtextdocumentlayout_p.h",
        ]
    }

    QtGuiHeaders {
        name: "headers (moc)"
        fileTags: "moc_hpp"
        excludeFiles: {
            var files = [
                "util/qlayoutpolicy_p.h", // "Class declaration lacks Q_OBJECT macro."
            ].concat(headers_moc_p.files);

            return files;
        }
    }

    Group {
        name: "sources (moc)"
        prefix: basePath + "/"
        files: [
            "image/qpixmapcache.cpp",
            "util/qdesktopservices.cpp",
        ]
        fileTags: "moc_cpp"
        overrideTags: false
    }

    Group {
        name: "accessible"
        prefix: basePath + "/accessible/"
        files: [
            "qaccessible.cpp",
            "qaccessiblebridge.cpp",
            "qaccessiblecache.cpp",
            "qaccessibleobject.cpp",
            "qaccessibleplugin.cpp",
            "qplatformaccessibility.cpp",
            //"qaccessiblecache_mac.mm", //### mac
        ]
    }

    Group {
        name: "animation"
        prefix: basePath + "/animation/"
        files: [
            "qguivariantanimation.cpp",
        ]
    }

    Group {
        name: "image"
        prefix: basePath + "/image/"
        files: [
            "qbitmap.cpp",
            "qbmphandler.cpp",
            "qgifhandler.cpp",
            "qicon.cpp",
            "qiconengine.cpp",
            "qiconengineplugin.cpp",
            "qiconloader.cpp",
            "qimage.cpp",
            "qimage_compat.cpp",
            "qimage_conversions.cpp",
            //"qimage_mips_dspr2.cpp",      // ### mips
            "qimage_neon.cpp",
            "qimage_sse2.cpp",
            "qimage_ssse3.cpp",
            "qimageiohandler.cpp",
            "qimagepixmapcleanuphooks.cpp",
            "qimagereader.cpp",
            "qimagewriter.cpp",
            "qjpeghandler.cpp",           // ### plugin
            "qmovie.cpp",
            "qnativeimage.cpp",
            "qpaintengine_pic.cpp",
            "qpicture.cpp",
            "qpictureformatplugin.cpp",
            "qpixmap.cpp",
            "qpixmap_blitter.cpp",
            "qpixmap_raster.cpp",
            "qplatformpixmap.cpp",
            "qpnghandler.cpp",
            "qppmhandler.cpp",
            "qxbmhandler.cpp",
            "qxpmhandler.cpp",
        ]
    }

    Group {
        name: "image_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: basePath + "/image/"
        files: [
            "qpixmap_win.cpp",
        ]
    }

    Group {
        name: "itemmodels"
        prefix: basePath + "/itemmodels/"
        files: [
            "qstandarditemmodel.cpp",
        ]
    }

    Group {
        name: "kernel"
        prefix: basePath + "/kernel/"
        files: [
            "qdrag.cpp",
            "qevent.cpp",
            "qgenericplugin.cpp",
            "qgenericpluginfactory.cpp",
            "qguiapplication.cpp",
            "qguivariant.cpp",
            "qinputmethod.cpp",
            "qinputdevicemanager.cpp",
            "qkeymapper.cpp",
            "qkeysequence.cpp",
            "qoffscreensurface.cpp",
            "qopenglcontext.cpp",
            "qopenglwindow.cpp",
            "qpaintdevicewindow.cpp",
            "qpalette.cpp",
            "qpixelformat.cpp",
            "qplatformclipboard.cpp",
            "qplatformcursor.cpp",
            "qplatformdialoghelper.cpp",
            "qplatformdrag.cpp",
            "qplatformgraphicsbuffer.cpp",
            "qplatformgraphicsbufferhelper.cpp",
            "qplatforminputcontext.cpp",
            "qplatforminputcontextfactory.cpp",
            "qplatforminputcontextplugin.cpp",
            "qplatformintegration.cpp",
            "qplatformintegrationfactory.cpp",
            "qplatformintegrationplugin.cpp",
            "qplatformmenu.cpp",
            "qplatformnativeinterface.cpp",
            "qplatformoffscreensurface.cpp",
            "qplatformopenglcontext.cpp",
            "qplatformscreen.cpp",
            "qplatformservices.cpp",
            "qplatformsessionmanager.cpp",
            "qplatformsharedgraphicscache.cpp",
            "qplatformsurface.cpp",
            "qplatformsystemtrayicon.cpp",
            "qplatformtheme.cpp",
            "qplatformthemefactory.cpp",
            "qplatformthemeplugin.cpp",
            "qplatformwindow.cpp",
            "qrasterwindow.cpp",
            "qscreen.cpp",
            "qsessionmanager.cpp",
            "qshapedpixmapdndwindow.cpp",
            "qshortcutmap.cpp",
            "qsimpledrag.cpp",
            "qstylehints.cpp",
            "qsurface.cpp",
            "qsurfaceformat.cpp",
            "qtouchdevice.cpp",
            "qwindow.cpp",
            "qwindowsysteminterface.cpp",
            "qclipboard.cpp",
            "qcursor.cpp",
            "qdnd.cpp",
        ]
    }

    Group {
        name: "math3d"
        prefix: basePath + "/math3d/"
        files: [
            "qgenericmatrix.cpp",
            "qmatrix4x4.cpp",
            "qquaternion.cpp",
            "qvector2d.cpp",
            "qvector3d.cpp",
            "qvector4d.cpp",
        ]
    }

    Group {
        name: "opengl"
        prefix: basePath + "/opengl/"
        files: [
            "qopenglbuffer.cpp",
            "qopenglcustomshaderstage.cpp",
            "qopengldebug.cpp",
            "qopenglengineshadermanager.cpp",
            "qopenglframebufferobject.cpp",
            "qopenglfunctions.cpp",
            "qopenglgradientcache.cpp",
            "qopenglpaintdevice.cpp",
            "qopenglpaintengine.cpp",
            "qopenglpixeltransferoptions.cpp",
            "qopenglshaderprogram.cpp",
            "qopengltexture.cpp",
            "qopengltextureblitter.cpp",
            "qopengltexturecache.cpp",
            "qopengltextureglyphcache.cpp",
            "qopengltexturehelper.cpp",
            "qopenglversionfunctions.cpp",
            "qopenglversionfunctionsfactory.cpp",
            "qopenglvertexarrayobject.cpp",
            "qtriangulatingstroker.cpp",
            "qtriangulator.cpp",
            "qopengl.cpp",
            "qopengl2pexvertexarray.cpp",
        ]
    }

    Group {
        name: "opengl_es2"
        condition: QtHost.config.opengl == "es2"
        prefix: basePath + "/opengl/"
        files: [
            "qopenglfunctions_es2.cpp",
        ]
    }

    Group {
        name: "opengl_desktop"
        condition: QtHost.config.opengl == "desktop"
        prefix: basePath + "/opengl/"
        files: [
            "qopenglfunctions_1_0.cpp",
            "qopenglfunctions_1_1.cpp",
            "qopenglfunctions_1_2.cpp",
            "qopenglfunctions_1_3.cpp",
            "qopenglfunctions_1_4.cpp",
            "qopenglfunctions_1_5.cpp",
            "qopenglfunctions_2_0.cpp",
            "qopenglfunctions_2_1.cpp",
            "qopenglfunctions_3_0.cpp",
            "qopenglfunctions_3_1.cpp",
            "qopenglfunctions_3_2_compatibility.cpp",
            "qopenglfunctions_3_2_core.cpp",
            "qopenglfunctions_3_3_compatibility.cpp",
            "qopenglfunctions_3_3_core.cpp",
            "qopenglfunctions_4_0_compatibility.cpp",
            "qopenglfunctions_4_0_core.cpp",
            "qopenglfunctions_4_1_compatibility.cpp",
            "qopenglfunctions_4_1_core.cpp",
            "qopenglfunctions_4_2_compatibility.cpp",
            "qopenglfunctions_4_2_core.cpp",
            "qopenglfunctions_4_3_compatibility.cpp",
            "qopenglfunctions_4_3_core.cpp",
            "qopengltimerquery.cpp",
        ]
    }

    Group {
        name: "painting"
        prefix: basePath + "/painting/"
        files: [
            "qbezier.cpp",
            "qblendfunctions.cpp",
            "qblittable.cpp",
            "qbrush.cpp",
            "qcolor.cpp",
            "qcolor_p.cpp",
            "qcosmeticstroker.cpp",
            "qcssutil.cpp",
            "qdrawhelper.cpp",
            //"qdrawhelper_mips_dsp.cpp",       // ## mips
            //"qdrawhelper_mips_dsp_asm.S",
            //"qdrawhelper_mips_dspr2_asm.S",
            "qdrawhelper_sse2.cpp",
            "qdrawhelper_ssse3.cpp",
            "qemulationpaintengine.cpp",
            "qgammatables.cpp",
            "qgrayraster.c",
            "qimagescale.cpp",
            "qmatrix.cpp",
            "qmemrotate.cpp",
            "qoutlinemapper.cpp",
            "qpagedpaintdevice.cpp",
            "qpagelayout.cpp",
            "qpagesize.cpp",
            "qpaintdevice.cpp",
            "qpaintengine.cpp",
            "qpaintengine_blitter.cpp",
            "qpaintengine_raster.cpp",
            "qpaintengineex.cpp",
            "qpainter.cpp",
            "qpainterpath.cpp",
            "qpathclipper.cpp",
            "qpathsimplifier.cpp",
            "qpdf.cpp",
            "qpdfwriter.cpp",
            "qpen.cpp",
            "qplatformbackingstore.cpp",
            "qpolygon.cpp",
            "qrasterizer.cpp",
            "qregion.cpp",
            "qstroker.cpp",
            "qtextureglyphcache.cpp",
            "qtransform.cpp",
            "qbackingstore.cpp",
        ]
    }

    Group {
        name: "opengl_arm"
        condition: qbs.architecture == "arm"
        prefix: basePath + "/painting/"
        files: [
            "qdrawhelper_neon.cpp",
            "qdrawhelper_neon_asm.S",
        ]
    }

    Group {
        name: "text"
        prefix: basePath + "/text/"
        files: [
            "qabstracttextdocumentlayout.cpp",
            "qcssparser.cpp",
            //"qcssscanner.cpp",
            "qdistancefield.cpp",
            "qfont.cpp",
            "qfontdatabase.cpp",
            "qfontengine.cpp",
            "qfontengine_ft.cpp",
            "qfontengine_qpf2.cpp",
            "qfontmetrics.cpp",
            "qfontsubset.cpp",
            "qfontsubset_agl.cpp",
            "qfragmentmap.cpp",
            "qglyphrun.cpp",
            //"qharfbuzzng.cpp",            // ### hb-ng
            "qplatformfontdatabase.cpp",
            "qrawfont.cpp",
            "qstatictext.cpp",
            "qsyntaxhighlighter.cpp",
            "qtextcursor.cpp",
            "qtextdocument.cpp",
            "qtextdocument_p.cpp",
            "qtextdocumentfragment.cpp",
            "qtextdocumentlayout.cpp",
            "qtextdocumentwriter.cpp",
            "qtextengine.cpp",
            "qtextformat.cpp",
            "qtexthtmlparser.cpp",
            "qtextimagehandler.cpp",
            "qtextlayout.cpp",
            "qtextlist.cpp",
            "qtextobject.cpp",
            "qtextodfwriter.cpp",
            "qtextoption.cpp",
            "qtexttable.cpp",
            "qzip.cpp",
        ]
    }

    Group {
        name: "util"
        prefix: basePath + "/util/"
        files: [
            "qabstractlayoutstyleinfo.cpp",
            "qgridlayoutengine.cpp",
            "qlayoutpolicy.cpp",
            "qvalidator.cpp",
        ]
    }

    Export {
        Depends { name: "QtHost.includes" }
        QtHost.includes.modules: ["gui", "gui-private"]
    }
}
