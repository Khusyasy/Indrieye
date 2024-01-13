import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:camera/camera.dart';

class ObstacleView extends StatefulWidget {
  const ObstacleView({Key? key}) : super(key: key);

  @override
  State<ObstacleView> createState() => _ObstacleViewState();
}

class _ObstacleViewState extends State<ObstacleView> {
  late List<CameraDescription> _cameras;
  CameraController? controller;

  bool _modelLoaded = false;
  bool _isDetecting = false;
  List<dynamic>? recognitions;
  Timer? _timer;

  Future<void> _processImage(CameraImage img) async {
    if (mounted) {
      setState(() {
        _isDetecting = true;
      });
    }
    if (_modelLoaded) {
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
        threshold: 0.3,
        asynch: true,
      );
    }
    // // ignore: avoid_print
    // print(recognitions);
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
    await Tflite.loadModel(
      model: "assets/obs_det.tflite",
      labels: "assets/obs_det_labelmap.txt",
      isAsset: true,
      numThreads: 4,
      useGpuDelegate: false,
    );
    _modelLoaded = true;
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
          _processImage(img);
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
    _timer?.cancel();
    _modelLoaded = false;
    Tflite.close();
    controller?.dispose();
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
