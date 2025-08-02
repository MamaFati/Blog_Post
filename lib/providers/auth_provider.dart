import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  final String _mockUsername = 'abufati876@gmail.com';
  final String _mockPassword = '24611';

  bool login(String username, String password) {
    if (username == _mockUsername && password == _mockPassword) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
