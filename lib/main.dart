import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:indrieye/pages/login_page.dart';
import 'package:indrieye/pages/navigation_page.dart';
import 'package:indrieye/pages/profile_page.dart';
import 'package:indrieye/pages/register_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var isLoggedIn = FirebaseAuth.instance.currentUser != null;
  runApp(MainApp(initialRoute: isLoggedIn ? '/home' : '/login'));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const NavigationPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/settings': (context) => const ProfilePage()
      },
    );
  }
}
