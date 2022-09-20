import 'package:flutter/material.dart';
import 'package:lrf/models/user_model.dart';
import 'package:lrf/services/database.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userModel;
  Map<String, dynamic> get getUser => _userModel!;
  final Database _database = Database();

  Future<void> refreshUser() async {
    Map<String, dynamic> user = await _database.getUserDetails();

    _userModel = user;
    // print(_userModel);
    notifyListeners();
  }
}
