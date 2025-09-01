import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';

class ProfileProvider extends ChangeNotifier {
  final _fs = FirestoreService();

  UserProfile? profile;
  bool loading = false;
  String? error;

  Stream<UserProfile?>? _sub;

  /// Start watching user profile changes
  void watchProfile(User user) {
    // cancel any previous subscription
    _sub = _fs.watchUserProfile(user.uid);
    _sub!.listen((p) {
      profile = p;
      notifyListeners();
    });
  }

  /// Create a new profile at registration
  Future<void> createInitial(
      User user, {
        required String displayName,
        String? gender,
        DateTime? dob,
        double? heightCm,
      }) async {
    final p = UserProfile(
      uid: user.uid,
      displayName: displayName,
      email: user.email ?? '',
      gender: gender,
      dob: dob,
      heightCm: heightCm,
    );
    await _fs.saveUserProfile(p);
  }

  /// Save updates to profile
  Future<void> save(UserProfile p) async {
    loading = true;
    notifyListeners();
    try {
      await _fs.saveUserProfile(p);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
