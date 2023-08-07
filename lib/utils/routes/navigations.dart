import 'package:flutter/material.dart';
import 'package:music_app/view/home_screen/components/search_page.dart';
import 'package:music_app/view/main%20page/main_page.dart';
import 'package:music_app/view/splash/splash_screen.dart';

class Navigations {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const splashScreen = "/splash_screen";
  static const mainPage = "/main_page";
  static const searchScreen = "/search_screen";

  static Map<String, Widget Function(BuildContext)> routes() {
    Map<String, Widget Function(BuildContext)> routes = {
      "/splash_screen": (context) => const SplashScreen(),
      "/main_page": (context) => const MainPage(),
      "/search_screen":(context)=> const SearchScreen(),
    };
    return routes;
  }
}
