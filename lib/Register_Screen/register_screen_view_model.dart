import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lend_bridge/User_Model/user_data_provider.dart';
import 'package:lend_bridge/User_Model/user_model.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  String? _emailError;
  String? _nameError;
  String? _phoneError;
  String? _passwordError;
  String? _generalError;
  bool _isLoading = false;

  String? get emailError => _emailError;

  String? get nameError => _nameError;

  String? get phoneError => _phoneError;

  String? get passwordError => _passwordError;

  String? get generalError => _generalError;

  bool get isLoading => _isLoading;

  final UserDataProvider userDataProvider;

  RegisterScreenViewModel(this.userDataProvider);

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

  Future<void> isValidFields(
    String email,
    String name,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    _generalError = null;
    _emailError = null;
    _nameError = null;
    _phoneError = null;
    _passwordError = null;
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

    if (name.isEmpty) {
      _nameError = 'Name can not be empty';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (phone.isEmpty) {
      _phoneError = 'Phone can not be empty';
      _isLoading = false;
      notifyListeners();
      return;
    } else if (phone.length != 10) {
      _phoneError = 'Enter a proper number';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      UserCredential? userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredentials.user;

      String uid = user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
        'isVerified': false,
      });

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _generalError = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }
}
