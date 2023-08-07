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
    requestPermission();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        Navigations.mainPage,
      ),
    );

    super.initState();
  }

  Future<bool> requestPermission() async {
    const storagePermission = Permission.storage;
    const mediaAccess = Permission.accessMediaLocation;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    try {
      if (await storagePermission.isGranted) {
        await mediaAccess.isGranted && await storagePermission.isGranted;
        return true;
      } else {
        if (deviceInfo.version.sdkInt > 32) {
          bool permissionStatus = await Permission.audio.request().isGranted;
          return permissionStatus;
        } else {
          var result = await storagePermission.request();
          var mediaresult = await mediaAccess.request();
          if (result == PermissionStatus.granted &&
              mediaresult == PermissionStatus.granted) {
            return true;
          } else {
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
                    Images.splashImage,
                    color: AppColors.appColor,
                  ),
                ),
                Text(
                  'MuSiCa',
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w800,
                    color: AppColors.appColor ?? AppColors.kblack,
                  ),
                ),
                const Text(
                  'Let the Musica Speak!',
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
