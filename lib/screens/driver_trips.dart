import 'package:flutter/material.dart';

class DriverTrips extends StatelessWidget {
  static const routeName = '/available_trips';
  const DriverTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Trips')),
      body: const Center(child: Text('Available Trips screen - placeholder')),
    );
  }
}