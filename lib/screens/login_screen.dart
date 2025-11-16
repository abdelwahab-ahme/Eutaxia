
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'terms_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool otpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    final ok = await ApiService.sendOtp(phone);
    setState(() { otpSent = ok; });
    if (ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent (mock)')));
  }

  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final code = otpController.text.trim();
    final ok = await ApiService.verifyOtp(phone, code);
    if (ok) {
      Navigator.pushReplacementNamed(context, TermsScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone (01012345678)')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: sendOtp, child: const Text('Send Verification Code')),
          const SizedBox(height: 12),
          TextField(controller: otpController, decoration: const InputDecoration(labelText: 'Enter verification code')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: verifyOtp, child: const Text('Verify & Continue')),
        ]),
      ),
    );
  }
}
