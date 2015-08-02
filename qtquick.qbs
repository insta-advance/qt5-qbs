import qbs
import "headers/QtQuickHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    condition: project.quick
    name: "QtQuick"
    simpleName: "quick"
    prefix: project.sourceDirectory + "/qtdeclarative/src/quick/"

    Product {
        name: module.privateName
        profiles: project.targetProfiles
        type: "hpp"
        Depends { name: module.moduleName }
        Export {
            Depends { name: "cpp" }
            cpp.defines: module.defines
            cpp.includePaths: module.includePaths
        }
    }

    QtHeaders {
        name: module.headersName
        sync.module: module.name
        ModuleHeaders { fileTags: "header_sync" }
    }

    QtModule {
        name: module.moduleName
        targetName: module.targetName

        Export {
            Depends { name: "cpp" }
            cpp.includePaths: module.publicIncludePaths
        }

        Depends { name: module.headersName }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.qml" }

        Depends { name: "gl"; condition: project.opengl }
        Depends { name: "glesv2"; condition: project.opengles2 }

        cpp.defines: [
            "QT_BUILD_QUICK_LIB",
        ].concat(base)

        cpp.dynamicLibraries: {
            var dynamicLibraries = base;
            if (qbs.targetOS.contains("windows"))
                dynamicLibraries.push("user32");
            return dynamicLibraries;
        }

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders { }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "accessible/qaccessiblequickitem.cpp",
                "accessible/qaccessiblequickview.cpp",
                "accessible/qquickaccessiblefactory.cpp",
                "designer/qqmldesignermetaobject.cpp",
                "designer/qquickdesignercustomobjectdata.cpp",
                "designer/qquickdesignersupport.cpp",
                "designer/qquickdesignersupportitems.cpp",
                "designer/qquickdesignersupportmetainfo.cpp",
                "designer/qquickdesignersupportproperties.cpp",
                "designer/qquickdesignersupportpropertychanges.cpp",
                "designer/qquickdesignersupportstates.cpp",
                "designer/qquickdesignerwindowmanager.cpp",
                "items/context2d/qquickcanvascontext.cpp",
                "items/context2d/qquickcanvasitem.cpp",
                "items/context2d/qquickcontext2dcommandbuffer.cpp",
                "items/context2d/qquickcontext2d.cpp",
                "items/context2d/qquickcontext2dtexture.cpp",
                "items/context2d/qquickcontext2dtile.cpp",
                "items/items.qrc",
                "items/qquickaccessibleattached.cpp",
                "items/qquickanchors.cpp",
                "items/qquickanimatedimage.cpp",
                "items/qquickanimatedsprite.cpp",
                "items/qquickborderimage.cpp",
                "items/qquickclipnode.cpp",
                "items/qquickdrag.cpp",
                "items/qquickdroparea.cpp",
                "items/qquickevents.cpp",
                "items/qquickflickable.cpp",
                "items/qquickflipable.cpp",
                "items/qquickfocusscope.cpp",
                "items/qquickframebufferobject.cpp",
                "items/qquickgridview.cpp",
                "items/qquickimagebase.cpp",
                "items/qquickimage.cpp",
                "items/qquickimplicitsizeitem.cpp",
                "items/qquickitemanimation.cpp",
                "items/qquickitem.cpp",
                "items/qquickitemgrabresult.cpp",
                "items/qquickitemsmodule.cpp",
                "items/qquickitemview.cpp",
                "items/qquickitemviewtransition.cpp",
                "items/qquicklistview.cpp",
                "items/qquickloader.cpp",
                "items/qquickmousearea.cpp",
                "items/qquickmultipointtoucharea.cpp",
                "items/qquickopenglinfo.cpp",
                "items/qquickpainteditem.cpp",
                "items/qquickpathview.cpp",
                "items/qquickpincharea.cpp",
                "items/qquickpositioners.cpp",
                "items/qquickrectangle.cpp",
                "items/qquickrendercontrol.cpp",
                "items/qquickrepeater.cpp",
                "items/qquickscalegrid.cpp",
                "items/qquickscreen.cpp",
                "items/qquickshadereffect.cpp",
                "items/qquickshadereffectmesh.cpp",
                "items/qquickshadereffectnode.cpp",
                "items/qquickshadereffectsource.cpp",
                "items/qquicksprite.cpp",
                "items/qquickspriteengine.cpp",
                "items/qquickspritesequence.cpp",
                "items/qquickstateoperations.cpp",
                "items/qquicktextcontrol.cpp",
                "items/qquicktext.cpp",
                "items/qquicktextdocument.cpp",
                "items/qquicktextedit.cpp",
                "items/qquicktextinput.cpp",
                "items/qquicktextnode.cpp",
                "items/qquicktextnodeengine.cpp",
                "items/qquicktextutil.cpp",
                "items/qquicktranslate.cpp",
                "items/qquickview.cpp",
                "items/qquickwindowattached.cpp",
                "items/qquickwindow.cpp",
                "items/qquickwindowmodule.cpp",
                "qtquick2.cpp",
                "scenegraph/coreapi/qsgabstractrenderer.cpp",
                "scenegraph/coreapi/qsgbatchrenderer.cpp",
                "scenegraph/coreapi/qsggeometry.cpp",
                "scenegraph/coreapi/qsgmaterial.cpp",
                "scenegraph/coreapi/qsgnode.cpp",
                "scenegraph/coreapi/qsgnodeupdater.cpp",
                "scenegraph/coreapi/qsgrenderer.cpp",
                "scenegraph/coreapi/qsgrendernode.cpp",
                "scenegraph/coreapi/qsgshaderrewriter.cpp",
                "scenegraph/qsgadaptationlayer.cpp",
                "scenegraph/qsgcontext.cpp",
                "scenegraph/qsgcontextplugin.cpp",
                "scenegraph/qsgdefaultdistancefieldglyphcache.cpp",
                "scenegraph/qsgdefaultglyphnode.cpp",
                "scenegraph/qsgdefaultglyphnode_p.cpp",
                "scenegraph/qsgdefaultimagenode.cpp",
                "scenegraph/qsgdefaultlayer.cpp",
                "scenegraph/qsgdefaultrectanglenode.cpp",
                "scenegraph/qsgdistancefieldglyphnode.cpp",
                "scenegraph/qsgdistancefieldglyphnode_p.cpp",
                "scenegraph/qsgrenderloop.cpp",
                "scenegraph/qsgthreadedrenderloop.cpp",
                "scenegraph/qsgwindowsrenderloop.cpp",
                "scenegraph/scenegraph.qrc",
                "scenegraph/util/qsgareaallocator.cpp",
                "scenegraph/util/qsgatlastexture.cpp",
                "scenegraph/util/qsgdefaultpainternode.cpp",
                "scenegraph/util/qsgdepthstencilbuffer.cpp",
                "scenegraph/util/qsgdistancefieldutil.cpp",
                "scenegraph/util/qsgengine.cpp",
                "scenegraph/util/qsgflatcolormaterial.cpp",
                "scenegraph/util/qsgshadersourcebuilder.cpp",
                "scenegraph/util/qsgsimplematerial.cpp",
                "scenegraph/util/qsgsimplerectnode.cpp",
                "scenegraph/util/qsgsimpletexturenode.cpp",
                "scenegraph/util/qsgtexture.cpp",
                "scenegraph/util/qsgtexturematerial.cpp",
                "scenegraph/util/qsgtextureprovider.cpp",
                "scenegraph/util/qsgvertexcolormaterial.cpp",
                "util/qquickanimationcontroller.cpp",
                "util/qquickanimation.cpp",
                "util/qquickanimatorcontroller.cpp",
                "util/qquickanimator.cpp",
                "util/qquickanimatorjob.cpp",
                "util/qquickapplication.cpp",
                "util/qquickbehavior.cpp",
                "util/qquickfontloader.cpp",
                "util/qquickfontmetrics.cpp",
                "util/qquickglobal.cpp",
                "util/qquickimageprovider.cpp",
                "util/qquickpath.cpp",
                "util/qquickpathinterpolator.cpp",
                "util/qquickpixmapcache.cpp",
                "util/qquickprofiler.cpp",
                "util/qquickpropertychanges.cpp",
                "util/qquickshortcut.cpp",
                "util/qquicksmoothedanimation.cpp",
                "util/qquickspringanimation.cpp",
                "util/qquickstatechangescript.cpp",
                "util/qquickstate.cpp",
                "util/qquickstategroup.cpp",
                "util/qquickstyledtext.cpp",
                "util/qquicksvgparser.cpp",
                "util/qquicksystempalette.cpp",
                "util/qquicktextmetrics.cpp",
                "util/qquicktimeline.cpp",
                "util/qquicktransition.cpp",
                "util/qquicktransitionmanager.cpp",
                "util/qquickutilmodule.cpp",
                "util/qquickvalidator.cpp",
                "util/qquickvaluetypes.cpp",
            ]
        }
    }
}
