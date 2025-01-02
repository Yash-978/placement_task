import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:placement_task/todo_app/provider/todo_provider.dart';
import 'package:placement_task/todo_app/view/screens/todo_home.dart';
import 'package:placement_task/users_auth_app/global.dart';
import 'package:placement_task/users_auth_app/modal/modal.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';
}

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }
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
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => TodoProvider(),
//         ),
//       ],
//       builder: (context, child) => MaterialApp(
//        debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         initialRoute: '/todo',
//         routes: {
//           '/todo': (context)=>const TodoHomePage(),
//
//         },
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       initialRoute: '/login',
//       getPages: [
//         GetPage(name: '/login', page: () => LoginScreen()),
//         GetPage(name: '/home', page: () => HomeScreen()),
//         GetPage(name: '/details', page: () => DetailsScreen()),
//         GetPage(name: '/all-users', page: () => AllUsersScreen()),
//       ],
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userDetails = await StorageHelper.getUserDetails();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.getBool('loginOrLogOut') ?? false;
  var con = Get.put(LoginController());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          userDetails == null || con.loginOrLogOut == true ? '/login' : '/home',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => HomeScreenData()),
        GetPage(name: '/logOutData', page: () => LogoutUser()),
        GetPage(name: '/details', page: () => DetailsScreen()),
      ],
    ),
  );
}

// class LoginScreen extends StatelessWidget {
//   final controller = Get.put(LoginController(), permanent: true);
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             Obx(() => controller.isLoading.value
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: () => controller.login(
//                 usernameController.text,
//                 passwordController.text,
//               ),
//               child: Text('Login'),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LoginScreen extends StatelessWidget {
  final controller = Get.put(LoginController(), permanent: true);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Login to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              Icon(Icons.person, color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      Obx(() => controller.isLoading.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => controller.login(
                                usernameController.text,
                                passwordController.text,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: Color(0xFF2575FC),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Handle Forgot Password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xFF2575FC)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenData extends StatelessWidget {
  const HomeScreenData({super.key});

  Future<List<Map<String, dynamic>>> getUserDetails() async {
    final userDetails = await StorageHelper.getUserDetails();
    return userDetails != null
        ? List<Map<String, dynamic>>.from(userDetails)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    var con = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              con.loginOrLogOut = false;
              Navigator.pushNamed(context, '/login');
              con.screenViewLogin();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final users = snapshot.data ?? [];
              if (users.isEmpty) {
                return Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/details', arguments: user);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            user['firstName']?.substring(0, 1) ?? '?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          user['firstName'] ?? 'No Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user['email'] ?? 'No Email'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class LogoutUser extends StatelessWidget {
  const LogoutUser({super.key});

  Future<List<Map<String, dynamic>>> getUserDetails() async {
    final userDetails = await StorageHelper.getUserDetails();
    return userDetails != null
        ? List<Map<String, dynamic>>.from(userDetails)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Logout User'),
        // actions: [
        //   PopupMenuItem(child: TextButton(onPressed: () {
        //     Get.toNamed('/home');
        //   }, child: Text('Show All Privous LogOut')))
        // ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('No LogOut users found'));
          }

          final users = snapshot.data ?? [];
          if (users.length == 1) {
            return Center(child: Text('No LogOut users found'));
          }

          return ListView.builder(
            itemCount: users.length - 1,
            itemBuilder: (context, index) {
              index = users.length - 2;
              final user = users[index];
              return ListTile(
                  title: Text(user['firstName'] ?? 'No Name'),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  onTap: () {
                    Get.toNamed('/details', arguments: user);
                  });
            },
          );
        },
      ),
    );
  }
}

/*
class DetailsScreen extends StatefulWidget {
  const DetailsScreen( {super.key });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AuthService _authService = AuthService();
  late Future<List<Map<String, dynamic>>> users;
  final user = Get.arguments;

  @override
  void initState() {
    super.initState();
    users = _authService.getAllUsers();  // Call the API to get all users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            final usersList = snapshot.data!;
            int dataIndex = 0;
            for(int i=0; i<usersList.length; i++)
            {
              if(user['firstName'] == usersList[i]['firstName'])
              {
                dataIndex = i;
              }
            }
            return  SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserImage(usersList[dataIndex]['image']),
                  _buildSectionTitle("Basic Information"),
                  _buildUserInfo("Username", usersList[dataIndex]['username']),
                  _buildUserInfo("Email", usersList[dataIndex]['email']),
                  _buildUserInfo("Phone", usersList[dataIndex]['phone']),
                  _buildUserInfo("Gender", usersList[dataIndex]['gender']),
                  _buildUserInfo("Age", usersList[dataIndex]['age'].toString()),
                  _buildUserInfo("Birth Date", usersList[dataIndex]['birthDate']),
                  _buildUserInfo("Role", usersList[dataIndex]['role']),
                  _buildSectionTitle("Appearance"),
                  _buildUserInfo("Height", "${usersList[dataIndex]['height']} cm"),
                  _buildUserInfo("Weight", "${usersList[dataIndex]['weight']} kg"),
                  _buildUserInfo("Eye Color", usersList[dataIndex]['eyeColor']),
                  _buildUserInfo("Hair Color", usersList[dataIndex]['hair']['color']),
                  _buildUserInfo("Hair Type", usersList[dataIndex]['hair']['type']),
                  _buildSectionTitle("Address"),
                  _buildUserInfo(
                      "Address",
                      "${usersList[dataIndex]['address']['address']}, ${usersList[dataIndex]['address']['city']}, ${usersList[dataIndex]['address']['state']} "
                          "(${usersList[dataIndex]['address']['postalCode']}), ${usersList[dataIndex]['address']['country']}"),
                  _buildUserInfo("Coordinates",
                      "Lat: ${usersList[dataIndex]['address']['coordinates']['lat']}, Lng: ${usersList[dataIndex]['address']['coordinates']['lng']}"),
                  _buildSectionTitle("Company"),
                  _buildUserInfo("Company Name", usersList[dataIndex]['company']['name']),
                  _buildUserInfo("Department", usersList[dataIndex]['company']['department']),
                  _buildUserInfo("Title", usersList[dataIndex]['company']['title']),
                  _buildUserInfo(
                      "Company Address",
                      "${usersList[dataIndex]['company']['address']['address']}, ${usersList[dataIndex]['company']['address']['city']}, "
                          "${usersList[dataIndex]['company']['address']['state']} (${usersList[dataIndex]['company']['address']['postalCode']})"),
                  _buildSectionTitle("Bank Details"),
                  _buildUserInfo("Card Type", usersList[dataIndex]['bank']['cardType']),
                  _buildUserInfo("Card Number", usersList[dataIndex]['bank']['cardNumber']),
                  _buildUserInfo("Card Expiry", usersList[dataIndex]['bank']['cardExpire']),
                  _buildUserInfo("IBAN", usersList[dataIndex]['bank']['iban']),
                  _buildSectionTitle("Crypto"),
                  _buildUserInfo("Coin", usersList[dataIndex]['crypto']['coin']),
                  _buildUserInfo("Wallet", usersList[dataIndex]['crypto']['wallet']),
                  _buildUserInfo("Network", usersList[dataIndex]['crypto']['network']),
                  _buildSectionTitle("Other Details"),
                  _buildUserInfo("IP", usersList[dataIndex]['ip']),
                  _buildUserInfo("Mac Address", usersList[dataIndex]['macAddress']),
                  _buildUserInfo("University", usersList[dataIndex]['university']),
                  _buildUserInfo("EIN", usersList[dataIndex]['ein']),
                  _buildUserInfo("SSN", usersList[dataIndex]['ssn']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  Widget _buildUserImage(String imageUrl) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
*/

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AuthService _authService = AuthService();
  late Future<List<Map<String, dynamic>>> users;
  final user = Get.arguments;

  @override
  void initState() {
    super.initState();
    users = _authService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.teal));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No users found.'));
              } else {
                final usersList = snapshot.data!;
                int dataIndex = usersList
                    .indexWhere((u) => u['firstName'] == user['firstName']);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildUserCard(usersList[dataIndex]),
                      const SizedBox(height: 20),
                      _buildSection('Basic Information', [
                        _buildUserInfo(
                            'Username', usersList[dataIndex]['username']),
                        _buildUserInfo('Email', usersList[dataIndex]['email']),
                        _buildUserInfo('Phone', usersList[dataIndex]['phone']),
                        _buildUserInfo(
                            'Gender', usersList[dataIndex]['gender']),
                        _buildUserInfo(
                            'Age', usersList[dataIndex]['age'].toString()),
                        _buildUserInfo(
                            'Birth Date', usersList[dataIndex]['birthDate']),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Appearance', [
                        _buildUserInfo(
                            'Height', '${usersList[dataIndex]['height']} cm'),
                        _buildUserInfo(
                            'Weight', '${usersList[dataIndex]['weight']} kg'),
                        _buildUserInfo(
                            'Eye Color', usersList[dataIndex]['eyeColor']),
                        _buildUserInfo('Hair Color',
                            usersList[dataIndex]['hair']['color']),
                        _buildUserInfo(
                            'Hair Type', usersList[dataIndex]['hair']['type']),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Address', [
                        _buildUserInfo(
                          'Address',
                          "${usersList[dataIndex]['address']['address']}, ${usersList[dataIndex]['address']['city']}, ${usersList[dataIndex]['address']['state']} (${usersList[dataIndex]['address']['postalCode']}), ${usersList[dataIndex]['address']['country']}",
                        ),
                        _buildUserInfo(
                          'Coordinates',
                          "Lat: ${usersList[dataIndex]['address']['coordinates']['lat']}, Lng: ${usersList[dataIndex]['address']['coordinates']['lng']}",
                        ),
                      ]),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> userData) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData['image']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${userData['firstName']} ${userData['lastName']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(userData['email'],
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 4),
                  Text('Role: ${userData['role']}',
                      style: TextStyle(color: Colors.teal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
        const SizedBox(height: 10),
        ...content,
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$label: ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  TextSpan(
                      text: value,
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
