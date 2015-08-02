import qbs
import "qbs/imports/QtUtils.js" as QtUtils
import "headers/QtMultimediaHeaders.qbs" as ModuleHeaders

QtModuleProject {
    id: module
    condition: project.multimedia
    name: "QtMultimedia"
    simpleName: "multimedia"
    prefix: project.sourceDirectory + "/qtmultimedia/src/multimedia/"

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
        Depends { name: "Qt.network" }

        Depends { name: "libpulse"; condition: project.pulseaudio }

        cpp.defines: [
            "QT_BUILD_MULTIMEDIA_LIB",
            "QT_MULTIMEDIA_QAUDIO",
        ].concat(base)

        cpp.includePaths: module.includePaths.concat(base)

        ModuleHeaders {
            excludeFiles: {
                var excludeFiles = [
                    "doc/**",
                    "qtmultimediaquicktools_headers/*.h", // moc'd by QtMultimediaTools
                    "gsttools_headers/*.h",               // moc'd by QtGstTools
                ];
                if (project.pulseaudio) {
                    excludeFiles.push("audio/qsoundeffect_qaudio_p.h");
                } else {
                    excludeFiles.push("audio/qsoundeffect_pulse_p.h");
                }
                return excludeFiles;
            }
        }

        Group {
            name: "sources"
            prefix: module.prefix
            files: [
                "qmediabindableinterface.cpp",
                "qmediacontrol.cpp",
                "qmediametadata.cpp",
                "qmediaobject.cpp",
                "qmediapluginloader.cpp",
                "qmediaresourcepolicy_p.cpp",
                "qmediaresourcepolicyplugin_p.cpp",
                "qmediaresourceset_p.cpp",
                "qmediaservice.cpp",
                "qmediaserviceprovider.cpp",
                "qmediastoragelocation.cpp",
                "qmediatimerange.cpp",
                "qmultimedia.cpp",
                "audio/qaudio.cpp",
                "audio/qaudiobuffer.cpp",
                "audio/qaudiodecoder.cpp",
                "audio/qaudiodevicefactory.cpp",
                "audio/qaudiodeviceinfo.cpp",
                "audio/qaudioformat.cpp",
                "audio/qaudiohelpers.cpp",
                "audio/qaudioinput.cpp",
                "audio/qaudiooutput.cpp",
                "audio/qaudioprobe.cpp",
                "audio/qaudiosystem.cpp",
                "audio/qaudiosystemplugin.cpp",
                "audio/qsamplecache_p.cpp",
                "audio/qsound.cpp",
                "audio/qsoundeffect.cpp",
                "audio/qwavedecoder_p.cpp",
                "camera/qcamera.cpp",
                "camera/qcameraexposure.cpp",
                "camera/qcamerafocus.cpp",
                "camera/qcameraimagecapture.cpp",
                "camera/qcameraimageprocessing.cpp",
                "camera/qcamerainfo.cpp",
                "camera/qcameraviewfindersettings.cpp",
                "controls/qaudiodecodercontrol.cpp",
                "controls/qaudioencodersettingscontrol.cpp",
                "controls/qaudioinputselectorcontrol.cpp",
                "controls/qaudiooutputselectorcontrol.cpp",
                "controls/qcameracapturebufferformatcontrol.cpp",
                "controls/qcameracapturedestinationcontrol.cpp",
                "controls/qcameracontrol.cpp",
                "controls/qcameraexposurecontrol.cpp",
                "controls/qcamerafeedbackcontrol.cpp",
                "controls/qcameraflashcontrol.cpp",
                "controls/qcamerafocuscontrol.cpp",
                "controls/qcameraimagecapturecontrol.cpp",
                "controls/qcameraimageprocessingcontrol.cpp",
                "controls/qcamerainfocontrol.cpp",
                "controls/qcameralockscontrol.cpp",
                "controls/qcameraviewfindersettingscontrol.cpp",
                "controls/qcamerazoomcontrol.cpp",
                "controls/qimageencodercontrol.cpp",
                "controls/qmediaaudioprobecontrol.cpp",
                "controls/qmediaavailabilitycontrol.cpp",
                "controls/qmediacontainercontrol.cpp",
                "controls/qmediagaplessplaybackcontrol.cpp",
                "controls/qmedianetworkaccesscontrol.cpp",
                "controls/qmediaplayercontrol.cpp",
                "controls/qmediaplaylistcontrol.cpp",
                "controls/qmediaplaylistsourcecontrol.cpp",
                "controls/qmediarecordercontrol.cpp",
                "controls/qmediastreamscontrol.cpp",
                "controls/qmediavideoprobecontrol.cpp",
                "controls/qmetadatareadercontrol.cpp",
                "controls/qmetadatawritercontrol.cpp",
                "controls/qradiodatacontrol.cpp",
                "controls/qradiotunercontrol.cpp",
                "controls/qvideodeviceselectorcontrol.cpp",
                "controls/qvideoencodersettingscontrol.cpp",
                "controls/qvideorenderercontrol.cpp",
                "controls/qvideowindowcontrol.cpp",
                "playback/playlistfileparser.cpp",
                "playback/qmediacontent.cpp",
                "playback/qmedianetworkplaylistprovider.cpp",
                "playback/qmediaplayer.cpp",
                "playback/qmediaplaylist.cpp",
                "playback/qmediaplaylistioplugin.cpp",
                "playback/qmediaplaylistnavigator.cpp",
                "playback/qmediaplaylistprovider.cpp",
                "playback/qmediaresource.cpp",
                "radio/qradiodata.cpp",
                "radio/qradiotuner.cpp",
                "video/qabstractvideobuffer.cpp",
                "video/qabstractvideofilter.cpp",
                "video/qabstractvideosurface.cpp",
                "video/qimagevideobuffer.cpp",
                "video/qmemoryvideobuffer.cpp",
                "video/qvideoframe.cpp",
                "video/qvideooutputorientationhandler.cpp",
                "video/qvideoprobe.cpp",
                "video/qvideosurfaceformat.cpp",
                "video/qvideosurfaceoutput.cpp",
                "recording/qaudiorecorder.cpp",
                "recording/qmediaencodersettings.cpp",
                "recording/qmediarecorder.cpp",
            ]
            excludeFiles: {
                var excludeFiles = [];
                if (project.pulseaudio)
                    excludeFiles.push("audio/qsoundeffect_qaudio_p.cpp");
                return excludeFiles;
            }
        }

        Group {
            name: "sources_pulseaudio"
            condition: project.pulseaudio
            prefix: module.prefix
            files: [
                "audio/qsoundeffect_pulse_p.cpp",
            ]
        }
    }

    QtModule {
        name: "Qt.qtmultimediaquicktools-private"
        targetName: "Qt5MultimediaQuick_p"

        cpp.defines: [
            "QT_BUILD_QTMM_QUICK_LIB",
        ].concat(base)

        Depends { name: module.moduleName }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.quick" }

        Depends { name: "gl"; condition: project.opengl }

        Group {
            name: "headers"
            prefix: project.sourceDirectory + "/qtmultimedia/src/"
            files: [
                "multimedia/qtmultimediaquicktools_headers/*.h",
                "qtmultimediaquicktools/*.h",
            ]
        }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtmultimedia/src/qtmultimediaquicktools/"
            files: [
                "qdeclarativevideooutput.cpp",
                "qdeclarativevideooutput_render.cpp",
                "qdeclarativevideooutput_window.cpp",
                "qsgvideonode_p.cpp",
                "qsgvideonode_rgb.cpp",
                "qsgvideonode_texture.cpp",
                "qsgvideonode_yuv.cpp",
                "qtmultimediaquicktools.qrc",
            ]
        }
    }

    QtModule {
        name: "QtGstTools"
        condition: project.gstreamer

        Depends { name: "gstreamer" }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.gui" }
        Depends { name: "Qt.multimedia" }

        Group {
            name: "headers"
            prefix: project.sourceDirectory + "/qtmultimedia/src/multimedia/gsttools_headers/"
            files: [
                "*.h",
            ]
            excludeFiles: [
                "qgstreamergltexturerenderer_p.h", // ### fixme: includes an x header which needs a probe
                "qgstreamervideowidget_p.h",       // ### fixme: requires QtMultmediaWidgetsHeaders
                "qvideosurfacegstsink_p.h", // gst 0.1
                "qgstreamermirtexturerenderer_p.h", // mir
            ]
        }

        Group {
            name: "sources"
            prefix: project.sourceDirectory + "/qtmultimedia/src/gsttools/"
            files: "*.cpp"
            excludeFiles: [
                "qgstreamergltexturerenderer.cpp", // ### fixme: see above
                "qgstreamervideowidget.cpp",       // ### fixme: see above
                "qvideosurfacegstsink.cpp", // gst 0.1
                "qgstreamermirtexturerenderer.cpp", // mir
            ]
        }
    }
}
