import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lend_bridge/Constants/Firebase_Constants.dart';
import 'package:lend_bridge/Login_Screen/login_screen_view_model.dart';
import 'package:lend_bridge/Register_Screen/register_screen_view_model.dart';
import 'package:lend_bridge/Splash_Screen/splash_screen_view.dart';
import 'package:lend_bridge/Splash_Screen/splash_screen_view_model.dart';
import 'package:lend_bridge/User_Model/user_data_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    const firebaseOptions = FirebaseOptions(
      apiKey: API_KEY,
      appId: APP_ID,
      messagingSenderId: MESSAGING_SENDER_ID,
      projectId: PROJECT_ID,
      databaseURL: DATABASE_URL,
      storageBucket: STORAGE_BUCKET,
    );

    await Firebase.initializeApp(options: firebaseOptions);

    debugPrint("Firebase connection successful");
  } catch (e) {
    debugPrint("Error in connection: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),

        ChangeNotifierProxyProvider<UserDataProvider, SplashScreenViewModel>(
          create: (context) => SplashScreenViewModel(
            Provider.of<UserDataProvider>(context, listen: false),
          ),
          update: (_, userProvider, __) => SplashScreenViewModel(userProvider),
        ),

        ChangeNotifierProxyProvider<UserDataProvider, LoginScreenViewModel>(
          create: (context) => LoginScreenViewModel(
            Provider.of<UserDataProvider>(context, listen: false),
          ),
          update: (_, userProvider, __) => LoginScreenViewModel(userProvider),
        ),

        ChangeNotifierProxyProvider<UserDataProvider, RegisterScreenViewModel>(
          create: (context) => RegisterScreenViewModel(
            Provider.of<UserDataProvider>(context, listen: false),
          ),
          update: (_, userProvider, __) =>
              RegisterScreenViewModel(userProvider),
        ),
      ],

      child: MaterialApp(title: 'Lend Bridge', home: SplashScreenView()),
    );
  }
}
