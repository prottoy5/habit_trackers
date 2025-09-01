import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _prefs = PrefsService();

  User? _user;
  bool _initializing = true;
  String? error;

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      _user = u;
      _initializing = false;
      notifyListeners();
    });
  }

  // Public getters
  User? get user => _user;
  bool get initializing => _initializing;
  bool get isLoggedIn => _user != null;

  Future<void> restoreSession() async {
    _initializing = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password, {bool remember = true}) async {
    try {
      await _auth.login(email: email, password: password);
      await _prefs.setRememberSession(remember);
      error = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _auth.register(email: email, password: password);
      error = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }

  /// 👈 Add this method to update password
  Future<void> updatePassword(String newPassword) async {
    if (_user == null) throw Exception("No user logged in");

    try {
      await _user!.updatePassword(newPassword); // Firebase method
      await _user!.reload(); // reload to refresh user data
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
}
