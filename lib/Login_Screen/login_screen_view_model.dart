import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lend_bridge/User_Model/user_data_provider.dart';
import 'package:lend_bridge/User_Model/user_model.dart';

class LoginScreenViewModel extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _emailError;

  String? _generalError;

  String? _passwordError;

  String? get emailError => _emailError;

  String? get generalError => _generalError;

  String? get passwordError => _passwordError;

  final UserDataProvider userDataProvider;

  LoginScreenViewModel(this.userDataProvider);

  bool isEmailValid(String email) {
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

  Future<void> isValidFields(String email, String password) async {
    _isLoading = true;
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    notifyListeners();

    if (email.isEmpty) {
      _emailError = 'Email can not be empty';
      _isLoading = false;
      notifyListeners();
      return;
    } else if (!isEmailValid(email)) {
      _emailError = 'Enter a valid email';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (password.isEmpty) {
      _passwordError = 'Password can not be empty';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      String uid = user!.uid;

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
      }

      _isLoading = false;
      notifyListeners();
      return;
    } on FirebaseAuthException catch (e) {
      _generalError = e.message;
      _isLoading = false;
      notifyListeners();
      return;
    }
  }
}
