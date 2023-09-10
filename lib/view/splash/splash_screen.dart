import 'dart:async';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/images.dart';
import 'package:music_app/utils/routes/navigations.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    userPermission();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacementNamed(
        context,
        Navigations.mainPage,
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
                    Images.splashImage,
                    color: AppColors.appColor,
                  ),
                ),
                Text(
                  'AudioScape',
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w800,
                    color: AppColors.appColor ?? AppColors.kblack,
                  ),
                ),
                const Text(
                  'Elevate your music experience with AudioScape',
                ),
                const SizedBox(
                  height: 50,
                ),
                Lottie.asset(
                  Lotties.splashLottie,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> requestPermission() async {
  const storagePermission = Permission.storage;
  final deviceInfo = await DeviceInfoPlugin().androidInfo;

  try {
    log("in permission");
    if (await storagePermission.isGranted) {
      log("11111111111111");
      await storagePermission.isGranted;
      return true;
    } else if (deviceInfo.version.sdkInt > 32) {
      log("Audio permission");
      if (await Permission.audio.isGranted) {
        log("audio video granted");
        return true;
      } else if (await Permission.audio.isPermanentlyDenied) {
        log("here");
        await openAppSettings();
        return true;
      }
      log("helo");
      await Permission.audio.request();

      return true;
    } else {
      log("2222222222");
      var result = await storagePermission.request();
      log("aaaaaaaaaaaaaaa");

      log("0000000000000000000");
      if (result == PermissionStatus.granted) {
        log("33333333333");
        return true;
      } else {
        log("4444444444");
        return false;
      }
    }
  } catch (e) {
    log("Error: $e");
    return false;
  }
}

Future userPermission() async {
  bool permission = await requestPermission();
  if (!permission) {
    await openAppSettings();
  }
}
