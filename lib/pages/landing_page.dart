import 'package:flutter/material.dart';
import 'package:indrieye/theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: Image.asset('assets/images/landing.png'),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Selamat datang di ',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextSpan(
                          text: 'Indrieye',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Masuk menggunakan akunmu atau daftar dengan akun baru',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: elevatedButtonStyle(context),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('MASUK'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: outlinedButtonStyle(context),
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('DAFTAR'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
