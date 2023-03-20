import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/screens/main_Screen/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      ),
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Image.asset(
                    'assets/images/Logo.jpg',
                    color: Colors.purple[400],
                  ),
                ),
                Text(
                  'MuSiCa',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    color: Colors.purple[400],
                    letterSpacing: 10,
                  ),
                ),
                const Text(
                  'Let the Musica Speak!',
                ),
                const SizedBox(
                  height: 50,
                ),
                Lottie.asset(
                  'assets/lottie/splashlottie.json',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
