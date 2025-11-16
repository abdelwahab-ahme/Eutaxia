import 'package:flutter/material.dart';

class ClientTracking extends StatelessWidget {
  static const routeName = '/driver_tracking';
  const ClientTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Tracking')),
      body: const Center(child: Text('Driver Tracking screen - placeholder')),
    );
  }
}