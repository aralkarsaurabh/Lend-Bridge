import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2));

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print(user);

        setState(() {
          isLoading = false;
        });

        context.go('/login');

        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => LoginScreen(),
        //     transitionDuration: Duration.zero,
        //     reverseTransitionDuration: Duration.zero,
        //   ),
        // );

        return;
      } else {
        context.go('/home');
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => MainScreen(),
        //     transitionDuration: Duration.zero,
        //     reverseTransitionDuration: Duration.zero,
        //   ),
        // );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("$e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            Text(
              'Just checking for a moment....',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),

            SizedBox(height: 16),

            if (isLoading) CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
