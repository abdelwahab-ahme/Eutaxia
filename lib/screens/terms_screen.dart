import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  static const routeName = '/terms';
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms')),
      body: const Center(child: Text('Terms screen - placeholder')),
    );
  }
}