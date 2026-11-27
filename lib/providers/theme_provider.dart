import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mode clair / sombre conservé entre les lancements (bonus choisi en J0).
class ThemeProvider extends ChangeNotifier {
  static const _cle = 'mode_sombre';

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  /// Relit le choix précédent avant `runApp`.
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = prefs.getBool(_cle) == true ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Inverse clair / sombre et enregistre le choix.
  Future<void> basculer() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cle, _mode == ThemeMode.dark);
  }
}
