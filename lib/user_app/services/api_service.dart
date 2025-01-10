import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiUserService {
  String api = 'https://api.escuelajs.co/api/v1/users';

  Future<List> fetchApiData() async {
    // String api = "https://jsonplaceholder.typicode.com/todos";
    Uri url = Uri.parse(api);
    Response response = await http.get(url);
    if (response.statusCode == 200) {
      final json = response.body;
      final List data = jsonDecode(json);
      return data;
    } else {
      return [];
    }
  }
}


