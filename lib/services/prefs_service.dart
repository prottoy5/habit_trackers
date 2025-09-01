import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  Future<void> setIsDark(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('isDark', value);
  }

  Future<void> setRememberSession(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('rememberSession', value);
  }

  Future<bool> getRememberSession() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('rememberSession') ?? true;
  }
}
