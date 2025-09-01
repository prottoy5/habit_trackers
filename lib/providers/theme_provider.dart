import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class ThemeProvider extends ChangeNotifier {
  final _prefs = PrefsService();
  bool isDark;
  ThemeProvider({this.isDark = false});

  Future<void> toggle() async {
    isDark = !isDark;
    await _prefs.setIsDark(isDark);
    notifyListeners();
  }
}
