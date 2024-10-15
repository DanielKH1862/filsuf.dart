import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    // Clear any existing login data when the LoginScreen is initialized
    _clearLoginData();
  }

  Future<void> _clearLoginData() async {
    // TODO: Implement clearing of login data (e.g., tokens, user info)
    // This might involve clearing SharedPreferences or other storage
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse(
              'https://praktikum-cpanel-unbin.com/solev/lugowo/login.php'),
          body: {
            'email': _email,
            'password': _password,
          },
        ).timeout(const Duration(seconds: 10)); // Add a timeout

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['status'] == 'success') {
            // Store user ID in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userId', result['user']['id'].toString());

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WelcomeScreen(username: result['user']['username'])),
            );
          } else {
            _showErrorSnackBar('Invalid email or password');
          }
        } else {
          _showErrorSnackBar('Error: Server returned ${response.statusCode}');
        }
      } on SocketException catch (e) {
        _showErrorSnackBar('Network error: ${e.message}');
      } on TimeoutException catch (_) {
        _showErrorSnackBar('Connection timed out. Please try again.');
      } catch (e) {
        _showErrorSnackBar('An unexpected error occurred: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDarkMode
                ? [
                    const Color(0xFF2C2C2C),
                    const Color(0xFF1F1F1F)
                  ] // Dark mode gradient
                : [
                    const Color(0xFFFFEB3B),
                    const Color(0xFFFBC02D)
                  ], // Light mode yellow gradient
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.school,
                        size: 100,
                        color: isDarkMode
                            ? Colors.yellow[600]
                            : Colors.yellow[800],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                        onSaved: (value) => _email = value!,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        onSaved: (value) => _password = value!,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password functionality
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.amber[300]
                              : Colors.amber[700],
                          foregroundColor:
                              isDarkMode ? Colors.black87 : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to sign up screen
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required FormFieldSetter<String> onSaved,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.yellow[800]!.withOpacity(0.2)
            : Colors.yellow[600]!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        obscureText: obscureText,
        style:
            TextStyle(color: isDarkMode ? Colors.yellow[100] : Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: isDarkMode ? Colors.yellow[200] : Colors.black54),
          prefixIcon: Icon(icon,
              color: isDarkMode ? Colors.yellow[200] : Colors.black54),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
