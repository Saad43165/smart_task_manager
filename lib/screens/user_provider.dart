import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _dob = '';

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get dob => _dob;

  // Setters
  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void updateDob(String dob) {
    _dob = dob;
    notifyListeners();
  }
}
