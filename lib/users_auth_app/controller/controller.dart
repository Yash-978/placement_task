

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

int index = 0;
List<Map<String, dynamic>> userList = [];

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var loginOrLogOut = false;

  Future<void> loadDataLogin() async {
    final prefs = await SharedPreferences.getInstance();
    loginOrLogOut = prefs.getBool('loginOrLogOut') ?? false;
  }

  Future<void> screenViewLogin() async {
    loginOrLogOut = !loginOrLogOut;
    print(loginOrLogOut);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loginOrLogOut', loginOrLogOut);
  }

  Future<void> login(String username, String password) async {
    StorageHelper.getUserDetails();
    isLoading.value = true;
    print(userList);
    try {
      print(
          'userList is _____________________________________+===================================================================');
      final user = await _authService.login(username, password);
      // userList.add(user);
      userList.insert(index, user);
      index++;
      print(userList);
      print(index);
      await StorageHelper.saveUserDetails(userList);
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  LoginController() {
    screenViewLogin();
    loadDataLogin();
  }
}

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