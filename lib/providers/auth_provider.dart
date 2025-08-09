import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthProvider extends ChangeNotifier {
  
  String? _userEmail;

  String? get userEmail => _userEmail;
  bool get isLoggedIn => _userEmail != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final box = await Hive.openBox('settings');
    _userEmail = box.get('userEmail');
    notifyListeners();
  }

  Future<void> login(String email) async {
    _userEmail = email;
    final box = await Hive.openBox('settings');
    await box.put('userEmail', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _userEmail = null;
    final box = await Hive.openBox('settings');
    await box.delete('userEmail');
    notifyListeners();
  }
  
}
