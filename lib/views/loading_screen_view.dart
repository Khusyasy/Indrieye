import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 2),
  //   );

  //   _controller.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       _controller.repeat();
  //     }
  //   });

  //   _controller.forward();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          // 'https://lottie.host/fb8a1bf0-2ae9-43ad-8f3b-093bbec6cc53/S7RMvTOz4T.json',
          'https://lottie.host/eb97b81b-d91f-49d9-ae92-c48acb481521/EbEsAAD2hI.json',
          // controller: _controller,
          // repeat: false, // Menonaktifkan pengulangan animasi
        ),
      ),
    );
  }
}
