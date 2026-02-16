import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lend_bridge/Constants/Firebase_Constants.dart';
import 'package:lend_bridge/routes/app_router.dart';

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
    return MaterialApp.router(routerConfig: goRouter);
  }
}
