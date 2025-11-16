import 'package:flutter/material.dart';

class DriverTracking extends StatelessWidget {
  static const routeName = '/journey';
  const DriverTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journey')),
      body: const Center(child: Text('Journey screen - placeholder')),
    );
  }
}