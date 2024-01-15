import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:indrieye/utils/mlkit_utils.dart';
import 'package:indrieye/utils/object_detector_painter.dart';

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
          if (object.labels[0].confidence > 0.5) {
            processedObjects.add(object);
          }
        }
      }
      processedObjects.sort(
          (a, b) => b.labels[0].confidence.compareTo(a.labels[0].confidence));

      _isBusy = false;
      if (mounted) {
        setState(() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.previewOnly(
      previewFit: CameraPreviewFit.cover,
      previewAlignment: Alignment.center,
      previewPadding: const EdgeInsets.all(16),
      onImageForAnalysis: (img) => _processImageObstacle(img),
      imageAnalysisConfig: AnalysisConfig(
        androidOptions: const AndroidAnalysisOptions.nv21(
          width: 1024,
        ),
        maxFramesPerSecond: 4,
        autoStart: true,
      ),
      builder: (cameraModeState, preview) {
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
              _objects.elementAtOrNull(0),
              preview.rect,
            ),
          ],
        );
      },
    );
  }
}

class ObstacleInfo extends StatelessWidget {
  const ObstacleInfo(
    this.object,
    this.previewRect, {
    super.key,
  });

  final DetectedObject? object;
  final Rect previewRect;

  String generateArah() {
    // 1 2 3
    // 4 5 6
    // 7 8 9
    // 1 = kiri atas  , 2 = depan atas  , 3 = kanan atas
    // 4 = kiri       , 5 = depan       , 6 = kanan
    // 7 = kiri bawah , 8 = depan bawah , 9 = kanan bawah
    // TODO: masih salah karena preview terpotong, jadi ga sesuai posisi yang terdetect
    final rect = object!.boundingBox;
    final x = rect.center.dx;
    final y = rect.center.dy;
    final prevX = previewRect.width / 3;
    final prevY = previewRect.height / 3;
    if (x < prevX) {
      if (y < prevY) {
        return 'kiri atas';
      } else if (y < prevY * 2) {
        return 'kiri';
      } else {
        return 'kiri bawah';
      }
    } else if (x < prevX * 2) {
      if (y < prevY) {
        return 'depan atas';
      } else if (y < prevY * 2) {
        return 'depan';
      } else {
        return 'depan bawah';
      }
    } else {
      if (y < prevY) {
        return 'kanan atas';
      } else if (y < prevY * 2) {
        return 'kanan';
      } else {
        return 'kanan bawah';
      }
    }
  }

  String generateText() {
    final label = object!.labels[0];
    // final trackingId = object!.trackingId;
    return '${label.text} di ${generateArah()} Anda';
  }
  // TODO: TTS pas object terpilih berubah (?)

  @override
  Widget build(BuildContext context) {
    if (object == null || object!.labels.isEmpty) {
      return Container();
    }

    return Positioned(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 128,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 64,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                      child: Text(
                        generateText(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
