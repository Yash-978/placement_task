import 'package:flutter/material.dart';
import 'package:placement_task/todo_app/modal/modal.dart';
import 'package:placement_task/todo_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoProvider extends ChangeNotifier {
  ApiHelper apiHelper = ApiHelper();
  List todoList = [];
  bool isToggle = false;
  bool isDarkTheme = false;

  Future<List> fetchData() async {
    final todo = await apiHelper.fetchApiData();
    todoList = todo
        .map(
          (e) => TodoModal.fromMap(e),
        )
        .toList();
    return todoList;
  }

  TodoProvider() {
    _loadPreferences();
    fetchData();
  }

  void changeView() {
    isToggle = !isToggle;
    _savePreferences();
    notifyListeners();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isToggle', isToggle);
    prefs.setBool('isDarkTheme', isDarkTheme);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isToggle = prefs.getBool('isToggle') ?? false;
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }
}
