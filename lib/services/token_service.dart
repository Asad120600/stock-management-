import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'token';
  static const String _emailKey = 'email';

  // Store the access token and email
  Future<void> storeToken(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_emailKey, email);
  }

  // Retrieve the access token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Retrieve the email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Remove the access token and email
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
  }

  // Retrieve the user name from the email
  Future<String?> getUserName() async {
    try {
      final email = await getEmail();
      if (email != null && email.isNotEmpty) {
        // Use email to get user's name (you can add your own logic here)
        return email.split('@')[0]; // Using the part before '@' as a placeholder for the name
      } else {
        print('Email is null or empty');
      }
    } catch (e) {
      print('Error retrieving user name from email: $e');
    }
    return null;
  }
}
