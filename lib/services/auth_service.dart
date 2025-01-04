import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:9000";
  static const storage = FlutterSecureStorage();

  // Send OTP
  static Future<void> sendOtp(String contact) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/auth/sendOtp'),
        body: {'phoneNumber': contact},
      );

      if (response.statusCode != 200) {
        debugPrint("Failed to send OTP. Response: ${response.body}");
        throw Exception("Failed to send OTP");
      }

      debugPrint("OTP sent successfully to $contact");
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      throw e;
    }
  }

  // Verify OTP
  static Future<String> verifyOtp(String contact, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/verifyOtp"),
        body: {'phoneNumber': contact, 'otp': otp},
      );

      if (response.statusCode != 200) {
        debugPrint("Invalid OTP. Response: ${response.body}");
        throw Exception("Invalid OTP");
      }

      final token = response.body;
      debugPrint("test: ${token}");
      if (token == null) {
        debugPrint("Token not found in response. Response: ${response.body}");
        throw Exception("Token not found in response");
      }

      debugPrint("OTP verified successfully for $contact");
      return token;
    } catch (e) {
      debugPrint("Error verifying OTP: $e");
      throw e;
    }
  }

  // Resend OTP
  static Future<void> resendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/resendOtp"),
        body: {"phoneNumber": phoneNumber},
      );

      if (response.statusCode != 200) {
        debugPrint("Failed to resend OTP. Response: ${response.body}");
        throw Exception("Failed to resend OTP");
      }

      debugPrint("OTP resent successfully to $phoneNumber");
    } catch (e) {
      debugPrint("Error resending OTP: $e");
      throw e;
    }
  }

  //get token
  static Future<String?> getToken() async {
    try {
      final token = await storage.read(key: "token");
      debugPrint("Token fetched from FlutterSecureStorage: $token");
      return token;
    } catch (e) {
      debugPrint("Error fetching token: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    await storage.delete(key: "token"); // Delete token
    debugPrint("Token cleared from FlutterSecureStorage");
  }

}
