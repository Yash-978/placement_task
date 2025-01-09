import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {

  static Future<void> saveUserDetails(
      List<Map<String, dynamic>> userDetails,
      ) async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    print(userDetails);
    print(
        'data of save detail +++++++++++++++++++++======================================================================');
    // final prefs = await SharedPreferences.getInstance();
    await ref.setString('userDetails', json.encode(userDetails));
    // String jsonString = jsonEncode(userList);
    // await prefs.setString('userList', json.encode(userDetails.map((u) => u.toJson()).toList()));
  }

  static Future<List<Map<String, dynamic>>?> getUserDetails() async {
    // Simulate getting data from SharedPreferences or another storage mechanism
    final ref = await SharedPreferences.getInstance();
    final userData = ref.getString('userDetails');
    if (userData != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(userData));
    }
    return null;
  }

  StorageHelper() {
    getUserDetails();
  }
}