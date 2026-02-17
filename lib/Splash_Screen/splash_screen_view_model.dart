import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lend_bridge/User_Model/user_data_provider.dart';
import 'package:lend_bridge/User_Model/user_model.dart';

class SplashScreenViewModel extends ChangeNotifier {
  final UserDataProvider userDataProvider;

  SplashScreenViewModel(this.userDataProvider);

  bool _isChecking = false;

  bool get isChecking => _isChecking;

  Future<String> checkAuthStatus() async {
    _isChecking = true;
    notifyListeners();

    try {
      User? firebaseUser = await FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        _isChecking = false;
        notifyListeners();
        return 'login';
      }

      String uid = firebaseUser.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromFirestor(
          userDoc.data() as Map<String, dynamic>,
          uid,
        );

        userDataProvider.setUser(user);

        _isChecking = false;
        notifyListeners();

        return 'Home';
      } else {
        _isChecking = false;
        notifyListeners();
        return 'login';
      }
    } on FirebaseAuthException catch (e) {
      _isChecking = false;
      notifyListeners();
      return 'login';
    }
  }
}
