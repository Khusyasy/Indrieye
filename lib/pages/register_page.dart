import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indrieye/theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Daftarkan akun baru',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  const FormRegister(),
                  const TextToMasuk(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormRegister extends StatefulWidget {
  const FormRegister({Key? key}) : super(key: key);

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;


  // final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password yang dimasukkan terlalu lemah.'),
              ),
            );
          }
        } else if (e.code == 'email-already-in-use') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email sudah digunakan.'),
              ),
            );
          }
        }
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextFormField(
              //   controller: _namaController,
              //   keyboardType: TextInputType.emailAddress,
              //   textInputAction: TextInputAction.next,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Masukkan nama';
              //     }
              //     return null;
              //   },
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'NAMA',
              //     hintText: 'Masukkan nama-mu',
              //   ),
              // ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  }
                  // https://stackoverflow.com/a/50663835/10599311
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'EMAIL',
                  hintText: 'Masukkan email-mu',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: _obscureText,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'PASSWORD',
                  hintText: 'Masukkan password-mu',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: _obscureText
                        ? const Icon(Icons.visibility,
                            semanticLabel: 'Tampilkan password')
                        : const Icon(Icons.visibility_off,
                            semanticLabel: 'Sembunyikan password'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.go,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password kembali';
                  }
                  if (value != _passwordController.text) {
                    return "Password tidak sama";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'KONFIRMASI PASSWORD',
                  hintText: 'Masukkan password-mu',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : register,
                  style: elevatedButtonStyle(context),
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('DAFTAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextToMasuk extends StatelessWidget {
  const TextToMasuk({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: GestureDetector(
        onTap: () => Navigator.popAndPushNamed(context, "/login"),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text.rich(
              textAlign: TextAlign.left,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: 'MASUK',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF24D7FF),
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
