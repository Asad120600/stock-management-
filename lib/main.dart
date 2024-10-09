import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/views/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Start the app with the initialized prefs
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _getInitialScreen(), // Determine the initial screen based on login status
    );
  }

  Widget _getInitialScreen() {
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }
}
