import 'package:flutter/material.dart';
import 'package:lrf/models/user_model.dart';
import 'package:lrf/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _currentUserName;
  String get getCurrentUserName => _currentUserName!;
  String? _currentUserUid;
  String get getCurrentUserUid => _currentUserUid!;
  getCurrentUserNameFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValueName = prefs.getString('currentUserName');
    String? stringValueUid = prefs.getString('currentUserUid');

    _currentUserName = stringValueName ?? '';
    _currentUserUid = stringValueUid ?? '';

    notifyListeners();
  }
}
