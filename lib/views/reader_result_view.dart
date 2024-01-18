import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReaderResultView extends StatefulWidget {
  const ReaderResultView(this.result, {Key? key}) : super(key: key);

  final RecognizedText? result;

  @override
  State<ReaderResultView> createState() => _ReaderResultViewState();
}

class _ReaderResultViewState extends State<ReaderResultView> {
  FlutterTts flutterTts = FlutterTts();

  String teksHasil() {
    if (widget.result == null || widget.result!.text.isEmpty) {
      return 'Tidak terdeteksi';
    }
    return widget.result!.text;
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('id-ID');
    await flutterTts.speak(text);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  @override
  void initState() {
    _speak(teksHasil());
    super.initState();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Teks yang dibaca'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              teksHasil(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
