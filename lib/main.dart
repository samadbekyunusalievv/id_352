import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/add_new_movie_screen.dart';
import 'screens/bingo_game_screen.dart';
import 'screens/main_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

  runApp(BingoApp(isFirstLaunch: isFirstLaunch));

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }
}

class BingoApp extends StatelessWidget {
  final bool isFirstLaunch;

  BingoApp({required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [
        SystemUiOverlay.bottom,
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bingo Movies',
          initialRoute: isFirstLaunch ? '/welcome' : '/main',
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/premium': (context) => const PremiumScreen(),
            '/main': (context) => MainScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/add_movie': (context) => AddNewMovieScreen(),
            '/bingo_game': (context) => BingoGameScreen(),
          },
        );
      },
    );
  }
}
