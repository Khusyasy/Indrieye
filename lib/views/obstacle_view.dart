import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:indrieye/providers/camera_provider.dart';
import 'package:provider/provider.dart';
import 'package:indrieye/services/tflite_service.dart';

class ObstacleView extends StatefulWidget {
  const ObstacleView({Key? key}) : super(key: key);

  @override
  State<ObstacleView> createState() => _ObstacleViewState();
}

class _ObstacleViewState extends State<ObstacleView> {
  CameraController? controller;

  final TfliteService _tfliteService = TfliteService();
  bool _isDetecting = false;
  List<dynamic>? recognitions;
  Timer? _timer;

  Future<void> _processImage(CameraImage img) async {
    if (mounted) {
      setState(() {
        _isDetecting = true;
      });
    }
    recognitions = await _tfliteService.processImageSSDMobileNet(img);
    if (mounted) {
      setState(() {});
      _timer = Timer(const Duration(milliseconds: 250), () {
        setState(() {
          _isDetecting = false;
        });
      });
    }
  }

  Future<void> loadModel() async {
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    Provider.of<CameraProvider>(context, listen: false).initCamera().then((_) {
      setState(() {
        controller =
            Provider.of<CameraProvider>(context, listen: false).controller;
        controller?.startImageStream((CameraImage img) {

        if (!_isDetecting) {
            _timer?.cancel();

          _processImage(img);
        }
      });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Widget> _buildBoxes(Size imageSize) {
    List<Widget> boxes = [];
    if (recognitions != null) {
      for (var recognition in recognitions!) {
        Widget box = Positioned(
          left: recognition['rect']['x'] * imageSize.width,
          top: recognition['rect']['y'] * imageSize.height,
          child: Container(
            width: recognition['rect']['w'] * imageSize.width,
            height: recognition['rect']['h'] * imageSize.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
              ),
              child: Text(
                "${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        );
        boxes.add(box);
      }
    }
    return boxes;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: Text('Loading Camera'),
      );
    }

    return Stack(
      children: [
        CameraPreview(controller!),
        ..._buildBoxes(controller!.value.previewSize!),
      ],
    );
  }
}
