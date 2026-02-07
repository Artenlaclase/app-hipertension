import 'package:flutter/material.dart';
import '../../presentation/screens/disclaimer_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/home_screen.dart';

class AppRoutes {
  static const String disclaimer = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.disclaimer:
        return MaterialPageRoute(
          builder: (context) => DisclaimerScreen(
            onAccepted: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
            },
          ),
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(
            onCompleted: (profile) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            },
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
