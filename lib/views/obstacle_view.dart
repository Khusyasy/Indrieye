import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:indrieye/utils/coordinates_translator.dart';
import 'package:indrieye/utils/mlkit_utils.dart';
import 'package:indrieye/utils/object_detector_painter.dart';

import 'obstacle_info_view.dart';

class ObstacleView extends StatefulWidget {
  const ObstacleView({Key? key}) : super(key: key);

  @override
  State<ObstacleView> createState() => _ObstacleViewState();
}

class _ObstacleViewState extends State<ObstacleView> {
  ObjectDetector? _objectDetector;

  InputImage? currentImg;
  List<DetectedObject> _objects = [];
  bool _canProcess = false;
  bool _isBusy = false;

  DetectedObject? _currentObject;
  Preview? _preview;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    _createDetector();
    super.initState();
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector?.close();
    super.dispose();
  }

  void _createDetector() {
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.stream,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
    _canProcess = true;
  }

  Future _processImageObstacle(AnalysisImage img) async {
    if (_objectDetector == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final inputImage = img.toInputImage();
    setState(() {
      currentImg = inputImage;
    });
    try {
      List<DetectedObject> objects =
          await _objectDetector!.processImage(inputImage);

      List<DetectedObject> processedObjects = [];
      for (DetectedObject object in objects) {
        if (object.labels.isNotEmpty) {
          if (object.labels[0].confidence > 0.65) {
            processedObjects.add(object);
          }
        }
      }
      processedObjects.sort(
          (a, b) => b.labels[0].confidence.compareTo(a.labels[0].confidence));

      _isBusy = false;
      if (mounted) {
        setState(() {
          _setObject(processedObjects.elementAtOrNull(0));
          _objects = processedObjects;
        });
      }

      // for (DetectedObject detectedObject in _objects) {
      //   final rect = detectedObject.boundingBox;
      //   final trackingId = detectedObject.trackingId;
      //   print('DetectedObject $trackingId $rect');

      //   // for (Label label in detectedObject.labels) {
      //   //   print('DetectedObject ${label.text} ${label.confidence}');
      //   // }
      // }
    } catch (e) {
      _canProcess = false;
      _isBusy = false;
      _objectDetector?.close();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) {
      return;
    }
    await flutterTts.setLanguage('id-ID');
    await flutterTts.speak(text);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  void _setObject(DetectedObject? detObj) {
    if (detObj == null) {
      _stop();
      setState(() {
        _currentObject = null;
      });
      return;
    }

    if (_currentObject == null ||
        _currentObject!.trackingId != detObj.trackingId ||
        (_currentObject!.trackingId == detObj.trackingId &&
            teksArah(_currentObject!) != teksArah(detObj))) {
      setState(() {
        _speak(teksHasil(detObj));
        _currentObject = detObj;
      });
    }
  }

  String teksArah(DetectedObject detObj) {
    if (_preview == null || currentImg == null) {
      return '';
    }
    // 1 2 3
    // 1 = kiri, 2 = depan, 3 = kanan
    // TODO: berdasarkan orientasi device (?)
    final rect = detObj.boundingBox;
    final x = translateX(
        rect.center.dx,
        _preview!.previewSize,
        currentImg!.metadata!.size,
        currentImg!.metadata!.rotation,
        CameraLensDirection.back);
    final prevX = _preview!.previewSize.width / 3;
    if (x < prevX) {
      return 'kiri';
    } else if (x < (prevX * 2)) {
      return 'depan';
    } else {
      return 'kanan';
    }
  }

  String teksHasil(DetectedObject detObj) {
    final label = detObj.labels[0];
    return '${label.text} di ${teksArah(detObj)} Anda';
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.previewOnly(
      previewFit: CameraPreviewFit.cover,
      previewAlignment: Alignment.center,
      onImageForAnalysis: (img) => _processImageObstacle(img),
      imageAnalysisConfig: AnalysisConfig(
        androidOptions: const AndroidAnalysisOptions.nv21(
          width: 1024,
        ),
        maxFramesPerSecond: 4,
        autoStart: true,
      ),
      builder: (cameraModeState, preview) {
        _preview = preview;
        return Stack(
          children: [
            if (kDebugMode && currentImg != null)
              SizedBox(
                width: preview.rect.width,
                height: preview.rect.height,
                child: CustomPaint(
                  painter: ObjectDetectorPainter(
                    _objects,
                    currentImg!.metadata?.size ?? Size.zero,
                    currentImg!.metadata?.rotation ??
                        InputImageRotation.rotation90deg,
                    CameraLensDirection.back,
                  ),
                ),
              ),
            ObstacleInfo(
              _currentObject != null ? teksHasil(_currentObject!) : '',
            ),
          ],
        );
      },
    );
  }
}
