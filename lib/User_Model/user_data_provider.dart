import 'package:flutter/cupertino.dart';
import 'package:lend_bridge/User_Model/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUser(UserModel updateUser) {
    _currentUser = updateUser;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
