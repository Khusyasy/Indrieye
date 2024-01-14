import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Indrieye',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 32,
              fontFamily: 'SF Pro Text',
              fontWeight: FontWeight.w900,
              height: 0.05,
              letterSpacing: -0.61,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
