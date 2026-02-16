import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Login_Screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final cnfPasswordController = TextEditingController();

  String? emailError;
  String? phoneError;
  String? passwordError;
  String? cnfPasswordError;
  String? generalError;

  bool isLoading = false;

  bool emailValidation(String email) {
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
    } else if (!emailValidation(emailController.text.trim())) {
      emailError = 'Enter a valid email';
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError = 'Phone number can not be empty';
      return false;
    } else if (phoneController.text.trim().length > 10 ||
        phoneController.text.trim().length < 10) {
      phoneError = 'Enter a valid phone number';
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = 'Password can not be empty';
      return false;
    } else if (passwordController.text.trim() !=
        cnfPasswordController.text.trim()) {
      passwordError = 'Password is not matching';
      return false;
    }

    return emailError == null &&
        phoneError == null &&
        passwordError == null &&
        cnfPasswordError == null &&
        true;
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      generalError = null;
      isLoading = true;
    });

    if (!isValidFields()) {
      return;
    }

    try {
      UserCredential? credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = credentials.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'uid': user.uid,
          'createdAt': DateTime.now(),
        });
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );

      context.go('/login');

      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => LoginScreen(),
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: -0.5,
                ),
              ),

              Text(
                'We are excited to have you on board',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),

              SizedBox(height: 32),

              TextField(
                controller: nameController,

                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_2_outlined,
                    color: Colors.black,
                  ),

                  label: Text('Name', style: TextStyle(color: Colors.black)),

                  hint: Text(
                    'Enter your name',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  errorText: emailError,

                  prefixIcon: Icon(Icons.mail_outline, color: Colors.black),

                  label: Text('Email', style: TextStyle(color: Colors.black)),

                  hint: Text(
                    'Enter your email',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: phoneController,

                decoration: InputDecoration(
                  errorText: phoneError,

                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.black),

                  label: Text('Phone', style: TextStyle(color: Colors.black)),

                  hint: Text(
                    'Enter your phone',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                obscureText: true,

                controller: passwordController,

                decoration: InputDecoration(
                  errorText: passwordError,

                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: Colors.black,
                  ),

                  label: Text(
                    'Password',
                    style: TextStyle(color: Colors.black),
                  ),

                  hint: Text(
                    'Enter your password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                obscureText: true,

                controller: cnfPasswordController,

                decoration: InputDecoration(
                  errorText: cnfPasswordError,

                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: Colors.black,
                  ),

                  label: Text(
                    'Confirm Password',
                    style: TextStyle(color: Colors.black),
                  ),

                  hint: Text(
                    'Enter your confirm password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
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
                  isLoading ? null : createUserWithEmailAndPassword();
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Register',
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

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 12),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LoginScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },

                    child: Text(
                      'Sign in',
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
