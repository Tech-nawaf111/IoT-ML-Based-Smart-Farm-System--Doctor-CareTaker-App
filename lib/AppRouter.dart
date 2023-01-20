import 'package:flutter/material.dart';

import 'Splash_Screen.dart';


class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/login':
        // return MaterialPageRoute(
        //   builder: (_) => LoginPage(
        //   ),
        // );
      case '/signup':
        // return MaterialPageRoute(
        //   builder: (_) => SignUpPage(
        //
        //   ),
        // );
      // case '/createProfile':
      //   return MaterialPageRoute(
      //     builder: (_) => SettingsScreen(),
      //   );
      // case '/createProfile':
      //   return MaterialPageRoute(
      //     builder: (_) => SettingsScreen(),
      //   );
      // case '/createProfile':
      //   return MaterialPageRoute(
      //     builder: (_) => SettingsScreen(),
      //   );
      default:
        return null;
    }
  }
}
