import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final storage = FlutterSecureStorage();

  bool _isOtpSent = false;
  String? _errorMessage;
  int _resendAttempts = 0;

  Future<void> _sendOtp() async {
    setState(() {
      _errorMessage = null;
    });
    try {
      await AuthService.sendOtp(_contactController.text);
      // at sendOtp
      // The method 'sendOtp' isn't defined for the type 'AuthService'. (Documentation)  Try correcting the name to the name of an existing method, or defining a method named 'sendOtp'.
      setState(() {
        _isOtpSent = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to send OTP. Please try again.";
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _errorMessage = null;
    });
    try {
      final token = await AuthService.verifyOtp(
        _contactController.text,
        _otpController.text,
      );
      await storage.write(key: 'token', value: token); // Store token securely
      debugPrint("Token stored in FlutterSecureStorage: $token");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid OTP. Please try again.";
      });
    }
  }

  Future<void> _resendOtp() async {
    // if (_resendAttempts >= 3) {
    //   setState(() {
    //     _errorMessage = "Resend limit reached. Please wait.";
    //   });
    //   return;
    // }
    // _resendAttempts++;
    await _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Contact",
                prefixText: "+91 ",
              ),
            ),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "OTP"),
              ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            if (!_isOtpSent)
              ElevatedButton(
                onPressed: _sendOtp,
                child: const Text("Send OTP"),
              ),
            if (_isOtpSent)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text("Verify OTP"),
                  ),
                  TextButton(
                    onPressed: _resendOtp,
                    child: const Text("Resend OTP"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
