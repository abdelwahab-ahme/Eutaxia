
import 'package:flutter/material.dart';
import '../widgets/background_image.dart';
import 'role_screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(opacity: 0.5),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text('EGTaxi', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, RoleScreen.routeName),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(220, 48)),
                  child: const Text('Start'),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
