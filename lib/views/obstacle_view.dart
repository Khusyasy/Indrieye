import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';

class ObstacleView extends StatefulWidget {
  const ObstacleView({Key? key}) : super(key: key);

  @override
  State<ObstacleView> createState() => _ObstacleViewState();
}

class _ObstacleViewState extends State<ObstacleView> {
  late List<CameraDescription> _cameras;
  CameraController? controller;

  bool _isDetecting = false;
  Timer? _timer;

  List<dynamic>? recognitions;

  Future<void> _processImage(CameraImage img) async {
    _isDetecting = true;
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
      threshold: 0.4,
      asynch: true,
    );
    // // ignore: avoid_print
    // print(recognitions);
    setState(() {});
    _isDetecting = false;
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/obs_det.tflite",
      labels: "assets/obs_det_labelmap.txt",
      isAsset: true,
      numThreads: 4,
      useGpuDelegate: false,
    );
  }

  Future<void> loadCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller!.startImageStream((CameraImage img) async {
        if (!controller!.value.isStreamingImages) {
          controller!.stopImageStream();
          return;
        }

        if (!_isDetecting) {
          if (_timer == null || !_timer!.isActive) {
            _timer = Timer(const Duration(milliseconds: 100), () {
              _processImage(img);
            });
          }
        }
      });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please allow access to the camera'),
              ),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to access the camera'),
              ),
            );
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    loadCamera();
  }

  @override
  void dispose() {
    controller!.dispose();
    Tflite.close();
    super.dispose();
  }

List<Widget> _buildBoxes(Size imageSize) {
    List<Widget> boxes = [];

    if (recognitions != null) {
      for (var recognition in recognitions!) {
        double left = recognition['rect']['x'] * imageSize.width;
        double top = recognition['rect']['y'] * imageSize.height;
        double width = recognition['rect']['w'] * imageSize.width;
        double height = recognition['rect']['h'] * imageSize.height;

        Widget box = Positioned(
          left: left,
          top: top,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            child: Text(
              "${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 10,
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
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Durations.medium1,
          child: controller != null && controller!.value.isInitialized
              ? CameraPreview(controller!)
              : Container(),
        ),
        ..._buildBoxes(controller!.value.previewSize ?? const Size(1.0, 1.0)),
      ],
    );
  }
}
