import qbs
import qbs.File
import qbs.Probes

QtModule {
    name: "QtGui"
    readonly property path basePath: project.sourceDirectory + "/qtbase/src/gui/"

    cpp.defines: [
        "QT_BUILD_GUI_LIB",
    ].concat(base);

    Depends { name: "gl"; condition: project.opengl && !qbs.targetOS.contains("windows") }
    Depends { name: "glesv2"; condition: project.opengles2 }
    Depends { name: "freetype2" }
    Depends { name: "libjpeg" }
    Depends { name: "libpng" }
    Depends { name: "QtCore" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "zlib" }

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: [
            "opengl32",
            "user32",
            "gdi32",
        ]
    }

    QtGuiHeaders {
        name: "headers"
        excludeFiles: {
            var excludeFiles = ["doc/**"];
            if (project.opengl == "es2")
                excludeFiles.push("opengl/qopengltimerquery.h");
            return excludeFiles;
        }
    }

    Group {
        name: "sources"
        prefix: basePath
        files: [
            "accessible/qaccessiblebridge.cpp",
            "accessible/qaccessiblecache.cpp",
            "accessible/qaccessible.cpp",
            "accessible/qaccessibleobject.cpp",
            "accessible/qaccessibleplugin.cpp",
            "accessible/qplatformaccessibility.cpp",
            "animation/qguivariantanimation.cpp",
            "image/qbitmap.cpp",
            "image/qbmphandler.cpp",
            "image/qgifhandler.cpp",
            "image/qicon.cpp",
            "image/qiconengine.cpp",
            "image/qiconengineplugin.cpp",
            "image/qiconloader.cpp",
            "image/qimage_compat.cpp",
            "image/qimage_conversions.cpp",
            "image/qimage.cpp",
            "image/qimageiohandler.cpp",
            "image/qimagepixmapcleanuphooks.cpp",
            "image/qimagereader.cpp",
            "image/qimagewriter.cpp",
            "image/qjpeghandler.cpp",
            "image/qmovie.cpp",
            "image/qnativeimage.cpp",
            "image/qpaintengine_pic.cpp",
            "image/qpicture.cpp",
            "image/qpictureformatplugin.cpp",
            "image/qpixmap_blitter.cpp",
            "image/qpixmapcache.cpp",
            "image/qpixmap.cpp",
            "image/qpixmap_raster.cpp",
            "image/qplatformpixmap.cpp",
            "image/qpnghandler.cpp",
            "image/qppmhandler.cpp",
            "image/qxbmhandler.cpp",
            "image/qxpmhandler.cpp",
            "itemmodels/qstandarditemmodel.cpp",
            "kernel/qclipboard.cpp",
            "kernel/qcursor.cpp",
            "kernel/qdnd.cpp",
            "kernel/qdrag.cpp",
            "kernel/qevent.cpp",
            "kernel/qgenericplugin.cpp",
            "kernel/qgenericpluginfactory.cpp",
            "kernel/qguiapplication.cpp",
            "kernel/qguivariant.cpp",
            "kernel/qinputdevicemanager.cpp",
            "kernel/qinputmethod.cpp",
            "kernel/qkeymapper.cpp",
            "kernel/qkeysequence.cpp",
            "kernel/qoffscreensurface.cpp",
            "kernel/qopenglcontext.cpp",
            "kernel/qopenglwindow.cpp",
            "kernel/qpaintdevicewindow.cpp",
            "kernel/qpalette.cpp",
            "kernel/qpixelformat.cpp",
            "kernel/qplatformclipboard.cpp",
            "kernel/qplatformcursor.cpp",
            "kernel/qplatformdialoghelper.cpp",
            "kernel/qplatformdrag.cpp",
            "kernel/qplatformgraphicsbuffer.cpp",
            "kernel/qplatformgraphicsbufferhelper.cpp",
            "kernel/qplatforminputcontext.cpp",
            "kernel/qplatforminputcontextfactory.cpp",
            "kernel/qplatforminputcontextplugin.cpp",
            "kernel/qplatformintegration.cpp",
            "kernel/qplatformintegrationfactory.cpp",
            "kernel/qplatformintegrationplugin.cpp",
            "kernel/qplatformmenu.cpp",
            "kernel/qplatformnativeinterface.cpp",
            "kernel/qplatformoffscreensurface.cpp",
            "kernel/qplatformopenglcontext.cpp",
            "kernel/qplatformscreen.cpp",
            "kernel/qplatformservices.cpp",
            "kernel/qplatformsessionmanager.cpp",
            "kernel/qplatformsharedgraphicscache.cpp",
            "kernel/qplatformsurface.cpp",
            "kernel/qplatformsystemtrayicon.cpp",
            "kernel/qplatformtheme.cpp",
            "kernel/qplatformthemefactory.cpp",
            "kernel/qplatformthemeplugin.cpp",
            "kernel/qplatformwindow.cpp",
            "kernel/qrasterwindow.cpp",
            "kernel/qscreen.cpp",
            "kernel/qsessionmanager.cpp",
            "kernel/qshapedpixmapdndwindow.cpp",
            "kernel/qshortcutmap.cpp",
            "kernel/qsimpledrag.cpp",
            "kernel/qstylehints.cpp",
            "kernel/qsurface.cpp",
            "kernel/qsurfaceformat.cpp",
            "kernel/qtouchdevice.cpp",
            "kernel/qwindow.cpp",
            "kernel/qwindowsysteminterface.cpp",
            "math3d/qgenericmatrix.cpp",
            "math3d/qmatrix4x4.cpp",
            "math3d/qquaternion.cpp",
            "math3d/qvector2d.cpp",
            "math3d/qvector3d.cpp",
            "math3d/qvector4d.cpp",
            "opengl/qopengl2pexvertexarray.cpp",
            "opengl/qopenglbuffer.cpp",
            "opengl/qopengl.cpp",
            "opengl/qopenglcustomshaderstage.cpp",
            "opengl/qopengldebug.cpp",
            "opengl/qopenglengineshadermanager.cpp",
            "opengl/qopenglframebufferobject.cpp",
            "opengl/qopenglfunctions.cpp",
            "opengl/qopenglgradientcache.cpp",
            "opengl/qopenglpaintdevice.cpp",
            "opengl/qopenglpaintengine.cpp",
            "opengl/qopenglpixeltransferoptions.cpp",
            "opengl/qopenglshaderprogram.cpp",
            "opengl/qopengltextureblitter.cpp",
            "opengl/qopengltexturecache.cpp",
            "opengl/qopengltexture.cpp",
            "opengl/qopengltextureglyphcache.cpp",
            "opengl/qopengltexturehelper.cpp",
            "opengl/qopenglversionfunctions.cpp",
            "opengl/qopenglversionfunctionsfactory.cpp",
            "opengl/qopenglvertexarrayobject.cpp",
            "opengl/qtriangulatingstroker.cpp",
            "opengl/qtriangulator.cpp",
            "painting/qbackingstore.cpp",
            "painting/qbezier.cpp",
            "painting/qblendfunctions.cpp",
            "painting/qblittable.cpp",
            "painting/qbrush.cpp",
            "painting/qcolor.cpp",
            "painting/qcolor_p.cpp",
            "painting/qcompositionfunctions.cpp",
            "painting/qcosmeticstroker.cpp",
            "painting/qcssutil.cpp",
            "painting/qdrawhelper.cpp",
            "painting/qemulationpaintengine.cpp",
            "painting/qgammatables.cpp",
            "painting/qgrayraster.c",
            "painting/qimagescale.cpp",
            "painting/qmatrix.cpp",
            "painting/qmemrotate.cpp",
            "painting/qoutlinemapper.cpp",
            "painting/qpagedpaintdevice.cpp",
            "painting/qpagelayout.cpp",
            "painting/qpagesize.cpp",
            "painting/qpaintdevice.cpp",
            "painting/qpaintengine_blitter.cpp",
            "painting/qpaintengine.cpp",
            "painting/qpaintengineex.cpp",
            "painting/qpaintengine_raster.cpp",
            "painting/qpainter.cpp",
            "painting/qpainterpath.cpp",
            "painting/qpathclipper.cpp",
            "painting/qpathsimplifier.cpp",
            "painting/qpdf.cpp",
            "painting/qpdfwriter.cpp",
            "painting/qpen.cpp",
            "painting/qplatformbackingstore.cpp",
            "painting/qpolygon.cpp",
            "painting/qrasterizer.cpp",
            "painting/qregion.cpp",
            "painting/qstroker.cpp",
            "painting/qtextureglyphcache.cpp",
            "painting/qtransform.cpp",
            "text/qabstracttextdocumentlayout.cpp",
            "text/qcssparser.cpp",
            "text/qdistancefield.cpp",
            "text/qfont.cpp",
            "text/qfontdatabase.cpp",
            "text/qfontengine.cpp",
            "text/qfontengine_ft.cpp",
            "text/qfontengineglyphcache.cpp",
            "text/qfontengine_qpf2.cpp",
            "text/qfontmetrics.cpp",
            "text/qfontsubset.cpp",
            "text/qfragmentmap.cpp",
            "text/qglyphrun.cpp",
            "text/qplatformfontdatabase.cpp",
            "text/qrawfont.cpp",
            "text/qstatictext.cpp",
            "text/qsyntaxhighlighter.cpp",
            "text/qtextcursor.cpp",
            "text/qtextdocument.cpp",
            "text/qtextdocumentfragment.cpp",
            "text/qtextdocumentlayout.cpp",
            "text/qtextdocument_p.cpp",
            "text/qtextdocumentwriter.cpp",
            "text/qtextengine.cpp",
            "text/qtextformat.cpp",
            "text/qtexthtmlparser.cpp",
            "text/qtextimagehandler.cpp",
            "text/qtextlayout.cpp",
            "text/qtextlist.cpp",
            "text/qtextobject.cpp",
            "text/qtextodfwriter.cpp",
            "text/qtextoption.cpp",
            "text/qtexttable.cpp",
            "text/qzip.cpp",
            "util/qabstractlayoutstyleinfo.cpp",
            "util/qdesktopservices.cpp",
            "util/qgridlayoutengine.cpp",
            "util/qlayoutpolicy.cpp",
            "util/qvalidator.cpp",
        ]
    }

    Group {
        name: "sources_windows"
        condition: qbs.targetOS.contains("windows")
        prefix: product.basePath
        files: [
            "image/qpixmap_win.cpp",
        ]
    }

    Group {
        name: "sources_opengles2"
        condition: project.opengles2
        prefix: product.basePath
        files: [
            "opengl/qopenglfunctions_es2.cpp",
        ]
    }

    Group {
        name: "sources_opengl"
        condition: project.opengl
        prefix: product.basePath
        files: [
            "opengl/qopenglfunctions_1_0.cpp",
            "opengl/qopenglfunctions_1_1.cpp",
            "opengl/qopenglfunctions_1_2.cpp",
            "opengl/qopenglfunctions_1_3.cpp",
            "opengl/qopenglfunctions_1_4.cpp",
            "opengl/qopenglfunctions_1_5.cpp",
            "opengl/qopenglfunctions_2_0.cpp",
            "opengl/qopenglfunctions_2_1.cpp",
            "opengl/qopenglfunctions_3_0.cpp",
            "opengl/qopenglfunctions_3_1.cpp",
            "opengl/qopenglfunctions_3_2_compatibility.cpp",
            "opengl/qopenglfunctions_3_2_core.cpp",
            "opengl/qopenglfunctions_3_3_compatibility.cpp",
            "opengl/qopenglfunctions_3_3_core.cpp",
            "opengl/qopenglfunctions_4_0_compatibility.cpp",
            "opengl/qopenglfunctions_4_0_core.cpp",
            "opengl/qopenglfunctions_4_1_compatibility.cpp",
            "opengl/qopenglfunctions_4_1_core.cpp",
            "opengl/qopenglfunctions_4_2_compatibility.cpp",
            "opengl/qopenglfunctions_4_2_core.cpp",
            "opengl/qopenglfunctions_4_3_compatibility.cpp",
            "opengl/qopenglfunctions_4_3_core.cpp",
            "opengl/qopenglfunctions_4_4_compatibility.cpp",
            "opengl/qopenglfunctions_4_4_core.cpp",
            "opengl/qopenglfunctions_4_5_compatibility.cpp",
            "opengl/qopenglfunctions_4_5_core.cpp",
            "opengl/qopengltimerquery.cpp",
        ]
    }

    Group {
        name: "sources_harfbuzzng"
        condition: project.harfbuzzng
        prefix: product.basePath
        files: [
            "text/qharfbuzzng.cpp",
        ]
    }

    Group {
        name: "sources_sse2"
        condition: project.sse2
        prefix: product.basePath
        files: [
            "image/qimage_sse2.cpp",
            "painting/qdrawhelper_sse2.cpp",
        ]
    }

    Group {
        name: "sources_ssse3"
        condition: project.ssse3
        prefix: product.basePath
        files: [
            "image/qimage_ssse3.cpp",
            "painting/qdrawhelper_ssse3.cpp",
        ]
    }

    Group {
        name: "sources_sse4_1"
        condition: project.sse4_1
        prefix: product.basePath
        files: [
            "image/qimage_sse4.cpp",
            "painting/qimagescale_sse4.cpp",
            "painting/qdrawhelper_sse4.cpp",
        ]
    }

    Group {
        name: "sources_avx2"
        condition: project.avx2
        prefix: product.basePath
        files: [
            "image/qimage_avx2.cpp",
            "painting/qdrawhelper_avx2.cpp",
        ]
    }

    Group {
        name: "sources_mips_dspr2"
        condition: project.mips_dspr2
        prefix: product.basePath
        files: [
            "image/qimage_mips_dspr2.cpp",
            "painting/qdrawhelper_mips_dsp.cpp",
        ]
    }

    Group {
        name: "sources_neon"
        condition: project.neon
        prefix: project.sourceDirectory + "/qtbase/src/"
        files: [
            "3rdparty/pixman/pixman-arm-neon-asm.S",
            "gui/painting/qdrawhelper_neon_asm.S",
            "gui/image/qimage_neon.cpp",
            "painting/qdrawhelper_neon.cpp",
        ]
    }
}
