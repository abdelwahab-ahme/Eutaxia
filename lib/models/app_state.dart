import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String role = 'client';
  String tripType = 'normal';
  bool carModern = true;
  String priceMode = 'meter';

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setRole(String r) {
    role = r;
    notifyListeners();
  }

  void setTripType(String t) {
    tripType = t;
    notifyListeners();
  }

  void setCarModern(bool v) {
    carModern = v;
    notifyListeners();
  }

  void setPriceMode(String p) {
    priceMode = p;
    notifyListeners();
  }
}