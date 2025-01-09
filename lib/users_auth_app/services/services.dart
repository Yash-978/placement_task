import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';
}

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url =
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
    final response = await http.post(
      url,
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      String token = userData['accessToken'];
      await _saveToken(token);
      return json.decode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final accessToken = await _getToken();
    final url =
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the response and return the list of users
      // final userDetails = userData['user'];
      //     await StorageHelper.saveUserDetails(userDetails);  // Save user details
      //     return userData;
      final usersData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(usersData['users']);
      // await StorageHelper.saveUserDetails(userDetails);  // Save user details
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve the saved token
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ??
        ''; // Return an empty string if no token is found
  }
}

