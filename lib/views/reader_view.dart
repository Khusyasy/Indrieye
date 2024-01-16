import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:indrieye/utils/mlkit_utils.dart';
import 'package:indrieye/views/reader_result_view.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  final _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  RecognizedText? _recognizedText;

  bool _canProcess = false;
  bool _isBusy = false;

  @override
  void dispose() {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  Future _processImageText(AnalysisImage img) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final inputImage = img.toInputImage();
    _recognizedText = await _textRecognizer //
        .processImage(inputImage);
    // String text = recognizedText.text;
    // for (TextBlock block in _recognizedText!.blocks) {
    //   // final Rect rect = block.boundingBox;
    //   // final List<Point<int>> cornerPoints = block.cornerPoints;
    //   // final String text = block.text;
    //   // final List<String> languages = block.recognizedLanguages;
    //   for (TextLine line in block.lines) {
    //     debugPrint("TextBlock [${line.text}]");
    //     for (TextElement element in line.elements) {
    //       debugPrint("TextBlock    ${element.text}");
    //     }
    //   }
    // }
    if (mounted) {
      setState(() {});
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReaderResultView(_recognizedText),
        ),
      );
    }

    _isBusy = false;
    setState(() {
      _canProcess = false;
    });
  }

  void startProcessing() {
    if (!_canProcess) {
      setState(() {
        _canProcess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraAwesomeBuilder.previewOnly(
          onImageForAnalysis: (img) => _processImageText(img),
          imageAnalysisConfig: AnalysisConfig(
            androidOptions: const AndroidAnalysisOptions.nv21(
              width: 2048,
            ),
            maxFramesPerSecond: 5,
            autoStart: true,
          ),
          builder: (state, preview) {
            return Container();
          },
        ),
        GestureDetector(
          onDoubleTap: startProcessing,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: IconButton(
                    iconSize: 48,
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor:
                          Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(_canProcess ? 0.3 : 1),
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(_canProcess ? 0.3 : 1),
                    ),
                    icon: const Icon(
                      Icons.text_fields_rounded,
                      semanticLabel: 'Tombol untuk memulai membaca teks',
                    ),
                    onPressed: startProcessing,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
