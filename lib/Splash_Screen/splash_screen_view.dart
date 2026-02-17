import 'package:flutter/material.dart';
import 'package:lend_bridge/Login_Screen/login_screen_view.dart';
import 'package:lend_bridge/Splash_Screen/splash_screen_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final viewModel = Provider.of<SplashScreenViewModel>(
      context,
      listen: false,
    );

    await Future.delayed(Duration(seconds: 2));

    String route = await viewModel.checkAuthStatus();

    if (route == 'home') {
      print('User exists');
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginScreenView(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/LendBridge.png'),

            Text(
              'Lend Bridge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
              ),
            ),

            CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
