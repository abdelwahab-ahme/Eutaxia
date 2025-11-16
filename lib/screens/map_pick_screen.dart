import 'package:flutter/material.dart';

class MapPickScreen extends StatelessWidget {
  static const routeName = '/map_pick';
  const MapPickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Pick')),
      body: const Center(child: Text('Map Pick screen - placeholder')),
    );
  }
}