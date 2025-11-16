import 'package:flutter/material.dart';

class DriverHome extends StatelessWidget {
  static const routeName = '/driver_dashboard';
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: const Center(child: Text('Driver Dashboard screen - placeholder')),
    );
  }
}