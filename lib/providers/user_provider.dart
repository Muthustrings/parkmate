import 'package:flutter/material.dart';
import 'package:parkmate/models/user_model.dart';
import 'package:parkmate/services/database_helper.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    await DatabaseHelper.instance.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }
}
