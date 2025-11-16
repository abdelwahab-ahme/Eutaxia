
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../models/app_state.dart';
import 'package:provider/provider.dart';

class RoleScreen extends StatelessWidget {
  static const routeName = '/role';
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Role')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Select your role', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                onPressed: () { state.setRole('client'); Navigator.pushNamed(context, LoginScreen.routeName); },
                child: const Text('Client'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(140, 48)),
              ),
              ElevatedButton(
                onPressed: () { state.setRole('driver'); Navigator.pushNamed(context, LoginScreen.routeName); },
                child: const Text('Driver'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(140, 48)),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
