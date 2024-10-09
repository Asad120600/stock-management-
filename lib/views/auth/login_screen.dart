import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/views/auth/signup_screen.dart';
import 'package:stock_managment/views/screens/dashboard/dashboard_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Track password visibility
  bool _isLoading = false; // Track loading state
  bool _isButtonEnabled = false; // Track if the login button should be enabled

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }


// Inside your _login() function
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email and password.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading state
    });

    final url = Uri.parse('https://stock.cslancer.com/api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "email": _emailController.text,
          "password": _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Check if the 'access_token' key exists
        if (responseData.containsKey('access_token')) {
          final accessToken = responseData['access_token'];

          // Store the token and email using SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', accessToken); // Store the access token
          await prefs.setString('email', _emailController.text); // Store the email

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Access token not found in response.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        // Handle error response
        final responseData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: "Login failed: ${responseData['message'] ?? 'Unknown error'}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with the current context to get screen dimensions
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Top-left vector
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Vector 1.png',
                width: ScreenUtil.setWidth(150),
              ),
            ),
            // Bottom-right vector
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/Vector 2.png',
                width: ScreenUtil.setWidth(150),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(24.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil.setHeight(80)),
                  Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(50)),
                  Center(
                    child: Image.asset(
                      'assets/images/login.png',
                      height: ScreenUtil.setHeight(150),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(40)),
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(10)),
                  Text(
                    'Password:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          size: ScreenUtil.setSp(24),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic can be implemented here
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: ScreenUtil.setSp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
          SizedBox(
            width: double.infinity,
            height: ScreenUtil.setHeight(50),
            child: Button(
              onPressed: _isButtonEnabled
                  ? () => _login()
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please fill in your credentials.",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.purple, // Customize background color
                    behavior: SnackBarBehavior.floating, // Makes the SnackBar float
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adds margin around the SnackBar
                    duration: Duration(seconds: 2), // Set the duration of the SnackBar
                  ),
                );
              },
              text: _isLoading ? 'Logging in...' : 'Log In',
            ),
          ),



          SizedBox(height: ScreenUtil.setHeight(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: ScreenUtil.setSp(22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: ScreenUtil.setSp(22),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.setHeight(80)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
