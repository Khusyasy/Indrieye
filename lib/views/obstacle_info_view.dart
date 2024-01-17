import 'package:flutter/material.dart';

class ObstacleInfo extends StatelessWidget {
  const ObstacleInfo(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Container();
    }

    return Positioned(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 128,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 64,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
