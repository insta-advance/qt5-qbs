import qbs
import qbs.File

QtModule {
    id: qtmultimedia
    condition: project.multimedia !== false
    name: "QtMultimedia"

    readonly property path basePath: project.sourceDirectory + "/qtmultimedia/src/multimedia/"

    cpp.defines: [
        "QT_BUILD_MULTIMEDIA_LIB",
        "QT_MULTIMEDIA_QAUDIO",
    ].concat(base)

    Depends { name: "libpulse"; condition: project.pulseaudio }
    Depends { name: "QtCore" }
    Depends { name: "QtGui" }
    Depends { name: "QtNetwork" }
    Depends { name: "QtQml" }
    Depends { name: "QtQuick" }
    Depends { name: "QtCoreHeaders" }
    Depends { name: "QtGuiHeaders" }
    Depends { name: "QtNetworkHeaders" }
    Depends { name: "QtQmlHeaders" }
    Depends { name: "QtQuickHeaders" }
    Depends { name: "QtMultimediaHeaders" }

    QtMultimediaHeaders {
        name: "headers"
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
        prefix: basePath
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
        prefix: basePath
        files: [
            "audio/qsoundeffect_pulse_p.cpp",
        ]
    }
}
