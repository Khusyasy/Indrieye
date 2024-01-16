import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReaderResultView extends StatelessWidget {
  const ReaderResultView(this.result, {Key? key}) : super(key: key);

  final RecognizedText? result;

  String teksHasil() {
    if (result == null || result!.text.isEmpty) {
      return 'Tidak terdeteksi';
    }
    return result!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teks yang dibaca'),
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
