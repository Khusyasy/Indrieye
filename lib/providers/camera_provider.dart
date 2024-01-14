import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  late List<CameraDescription> _cameras = [];
  CameraController? _controller;

  List<CameraDescription> get cameras => _cameras;
  CameraController? get controller => _controller;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    notifyListeners();
    super.dispose();
  }
}
