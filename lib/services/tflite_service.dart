import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class TfliteService {
  static final TfliteService _instance = TfliteService._();
  bool modelLoaded = false;

  factory TfliteService() {
    return _instance;
  }

  TfliteService._();

  Future<void> loadModelSSDMobileNet() async {
    await Tflite.loadModel(
      model: "assets/obs_det.tflite",
      labels: "assets/obs_det_labelmap.txt",
      isAsset: true,
      numThreads: 4,
      useGpuDelegate: false,
    );
    modelLoaded = true;
  }

  Future<List<dynamic>?> processImageSSDMobileNet(CameraImage img) async {
    if (!modelLoaded) {
      await loadModelSSDMobileNet();
    }
    List<dynamic>? recognitions;
    try {
      recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "SSDMobileNet",
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        threshold: 0.5,
        asynch: true,
      );
    } catch (e) {
      print(e);
    }
    return recognitions;
  }

  // Future<void> dispose() async {
  //   await Tflite.close();
  // }
}
