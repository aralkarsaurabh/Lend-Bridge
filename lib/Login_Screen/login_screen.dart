import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Register_Screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? generalError;

  bool isLoading = false;

  bool isEmailvalid(String email) {
    if (!email.contains('@')) {
      return false;
    }

    int atIndex = email.indexOf('@');
    int dotIndex = email.indexOf('.', atIndex);

    if (dotIndex < atIndex) {
      return false;
    }

    return true;
  }

  bool isValidFields() {
    if (emailController.text.trim().isEmpty) {
      emailError = 'Email can not be empty';
      return false;
    } else if (!isEmailvalid(emailController.text.trim())) {
      emailError = 'Enter a valid email';
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = 'Password can not be empty';
      return false;
    }

    return emailError == null && passwordError == null && true;
  }

  Future<void> signInUserWithEmailAndPassword() async {
    setState(() {
      generalError == null;
      isLoading = true;
    });

    if (!isValidFields()) {
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );

      context.go('/home');

      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => DashboardScreen(),
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ),
      // );
    } on FirebaseAuthException catch (e) {
      setState(() {
        generalError = e.message;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),

              Text(
                'Get back to work by signing in',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),

              SizedBox(height: 32),

              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  errorText: emailError,

                  prefixIcon: Icon(Icons.mail_outline, color: Colors.black),

                  label: Text('Email', style: TextStyle(color: Colors.black)),

                  hint: Text(
                    'Enter you email',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: passwordController,

                obscureText: true,

                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Password',
                    style: TextStyle(color: Colors.black),
                  ),

                  hint: Text(
                    'Enter you password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),

              SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  backgroundColor: Colors.black,

                  minimumSize: Size(400, 54),
                ),
                onPressed: () {
                  isLoading ? null : signInUserWithEmailAndPassword();
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              SizedBox(height: 24),

              if (generalError != null)
                Text(
                  generalError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {},

                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 12),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => RegisterScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },

                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
