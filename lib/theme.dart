// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData themeMain = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFE924),
    brightness: Brightness.dark,
    background: Colors.black,
  ),
  fontFamily: 'Roboto',
);

ButtonStyle elevatedButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    onPrimary: Theme.of(context).colorScheme.onPrimary,
    primary: Theme.of(context).colorScheme.primary,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
}

ButtonStyle outlinedButtonStyle(BuildContext context) {
  return OutlinedButton.styleFrom(
    primary: Theme.of(context).colorScheme.primary,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  ).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(
            color: Colors.white,
            width: 1,
          );
        }
        return BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        );
      },
    ),
  );
}
