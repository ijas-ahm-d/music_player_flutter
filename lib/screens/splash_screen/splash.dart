import 'dart:async';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/screens/main_Screen/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    requestPermission();
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

  Future<bool> requestPermission() async {
    const storagePermission = Permission.storage;
    const mediaAccess = Permission.accessMediaLocation;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    try {
      log("in permission");
      if (await storagePermission.isGranted) {
        log("11111111111111");
        await mediaAccess.isGranted && await storagePermission.isGranted;
        return true;
      } else {
        if (deviceInfo.version.sdkInt > 32) {
          log("yyyyyyyy");
          bool permissionStatus = await Permission.audio.request().isGranted;
          return permissionStatus;
        } else {
          log("2222222222");
          var result = await storagePermission.request();
          log("aaaaaaaaaaaaaaa");
          var mediaresult = await mediaAccess.request();
          log("0000000000000000000");
          if (result == PermissionStatus.granted &&
              mediaresult == PermissionStatus.granted) {
            log("33333333333");
            return true;
          } else {
            log("4444444444");
            return false;
          }
        }
      }
    } catch (e) {
      log("Error: $e");
      return false;
    }
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
