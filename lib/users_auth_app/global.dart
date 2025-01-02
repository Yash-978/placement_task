import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';
}

// class UserModel {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//
//   UserModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       phone: json['phone'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'phone': phone,
//     };
//   }
// }

class UserModal {
  List<User> users;
  int total;
  int skip;
  int limit;

  UserModal({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UserModal.fromMap(Map<String, dynamic> json) => UserModal(
        users: List<User>.from(json["users"].map((x) => User.fromMap(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toMap() => {
        "users": List<dynamic>.from(users.map((x) => x.toMap())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class User {
  int id;
  String firstName;
  String lastName;
  String maidenName;
  int age;
  Gender gender;
  String email;
  String phone;
  String username;
  String password;
  String birthDate;
  String image;
  String bloodGroup;
  double height;
  double weight;
  String eyeColor;
  Hair hair;
  String ip;
  Address address;
  String macAddress;
  String university;
  Bank bank;
  Company company;
  String ein;
  String ssn;
  String userAgent;
  Crypto crypto;
  Role role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        maidenName: json["maidenName"],
        age: json["age"],
        gender: genderValues.map[json["gender"]]!,
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        password: json["password"],
        birthDate: json["birthDate"],
        image: json["image"],
        bloodGroup: json["bloodGroup"],
        height: json["height"]?.toDouble(),
        weight: json["weight"]?.toDouble(),
        eyeColor: json["eyeColor"],
        hair: Hair.fromMap(json["hair"]),
        ip: json["ip"],
        address: Address.fromMap(json["address"]),
        macAddress: json["macAddress"],
        university: json["university"],
        bank: Bank.fromMap(json["bank"]),
        company: Company.fromMap(json["company"]),
        ein: json["ein"],
        ssn: json["ssn"],
        userAgent: json["userAgent"],
        crypto: Crypto.fromMap(json["crypto"]),
        role: roleValues.map[json["role"]]!,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "maidenName": maidenName,
        "age": age,
        "gender": genderValues.reverse[gender],
        "email": email,
        "phone": phone,
        "username": username,
        "password": password,
        "birthDate": birthDate,
        "image": image,
        "bloodGroup": bloodGroup,
        "height": height,
        "weight": weight,
        "eyeColor": eyeColor,
        "hair": hair.toMap(),
        "ip": ip,
        "address": address.toMap(),
        "macAddress": macAddress,
        "university": university,
        "bank": bank.toMap(),
        "company": company.toMap(),
        "ein": ein,
        "ssn": ssn,
        "userAgent": userAgent,
        "crypto": crypto.toMap(),
        "role": roleValues.reverse[role],
      };
}

class Address {
  String address;
  String city;
  String state;
  String stateCode;
  String postalCode;
  Coordinates coordinates;
  Country country;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        address: json["address"],
        city: json["city"],
        state: json["state"],
        stateCode: json["stateCode"],
        postalCode: json["postalCode"],
        coordinates: Coordinates.fromMap(json["coordinates"]),
        country: countryValues.map[json["country"]]!,
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "city": city,
        "state": state,
        "stateCode": stateCode,
        "postalCode": postalCode,
        "coordinates": coordinates.toMap(),
        "country": countryValues.reverse[country],
      };
}

class Coordinates {
  double lat;
  double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromMap(Map<String, dynamic> json) => Coordinates(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}

enum Country { UNITED_STATES }

final countryValues = EnumValues({"United States": Country.UNITED_STATES});

class Bank {
  String cardExpire;
  String cardNumber;
  String cardType;
  String currency;
  String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromMap(Map<String, dynamic> json) => Bank(
        cardExpire: json["cardExpire"],
        cardNumber: json["cardNumber"],
        cardType: json["cardType"],
        currency: json["currency"],
        iban: json["iban"],
      );

  Map<String, dynamic> toMap() => {
        "cardExpire": cardExpire,
        "cardNumber": cardNumber,
        "cardType": cardType,
        "currency": currency,
        "iban": iban,
      };
}

class Company {
  String department;
  String name;
  String title;
  Address address;

  Company({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        department: json["department"],
        name: json["name"],
        title: json["title"],
        address: Address.fromMap(json["address"]),
      );

  Map<String, dynamic> toMap() => {
        "department": department,
        "name": name,
        "title": title,
        "address": address.toMap(),
      };
}

class Crypto {
  Coin coin;
  Wallet wallet;
  Network network;

  Crypto({
    required this.coin,
    required this.wallet,
    required this.network,
  });

  factory Crypto.fromMap(Map<String, dynamic> json) => Crypto(
        coin: coinValues.map[json["coin"]]!,
        wallet: walletValues.map[json["wallet"]]!,
        network: networkValues.map[json["network"]]!,
      );

  Map<String, dynamic> toMap() => {
        "coin": coinValues.reverse[coin],
        "wallet": walletValues.reverse[wallet],
        "network": networkValues.reverse[network],
      };
}

enum Coin { BITCOIN }

final coinValues = EnumValues({"Bitcoin": Coin.BITCOIN});

enum Network { ETHEREUM_ERC20 }

final networkValues = EnumValues({"Ethereum (ERC20)": Network.ETHEREUM_ERC20});

enum Wallet { THE_0_XB9_FC2_FE63_B2_A6_C003_F1_C324_C3_BFA53259162181_A }

final walletValues = EnumValues({
  "0xb9fc2fe63b2a6c003f1c324c3bfa53259162181a":
      Wallet.THE_0_XB9_FC2_FE63_B2_A6_C003_F1_C324_C3_BFA53259162181_A
});

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

class Hair {
  String color;
  Type type;

  Hair({
    required this.color,
    required this.type,
  });

  factory Hair.fromMap(Map<String, dynamic> json) => Hair(
        color: json["color"],
        type: typeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toMap() => {
        "color": color,
        "type": typeValues.reverse[type],
      };
}

enum Type { CURLY, KINKY, STRAIGHT, WAVY }

final typeValues = EnumValues({
  "Curly": Type.CURLY,
  "Kinky": Type.KINKY,
  "Straight": Type.STRAIGHT,
  "Wavy": Type.WAVY
});

enum Role { ADMIN, MODERATOR, USER }

final roleValues = EnumValues(
    {"admin": Role.ADMIN, "moderator": Role.MODERATOR, "user": Role.USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// class UserModel {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//
//   UserModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       phone: json['phone'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'phone': phone,
//     };
//   }
// }

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
      return json.decode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}

class StorageHelper {
  static const String _userDetailsKey = 'userDetails';
  static const String _userListKey = 'userList';

  // Save current user details
  static Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDetailsKey, json.encode(userDetails));

    // Also add to userList if not already present
    List<Map<String, dynamic>> userList = await getUserList();
    bool userExists = userList.any((user) => user['id'] == userDetails['id']);

    if (!userExists) {
      userList.add(userDetails);
      await prefs.setString(_userListKey, json.encode(userList));
    }
  }

  // Get current user details
  static Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDetails = prefs.getString(_userDetailsKey);
    if (userDetails != null) {
      return json.decode(userDetails);
    }
    return null;
  }

  // Get list of all logged-in users
  static Future<List<Map<String, dynamic>>> getUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final userListString = prefs.getString(_userListKey);
    if (userListString != null) {
      List<dynamic> decodedList = json.decode(userListString);
      return decodedList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDetailsKey);
    // Note: We don't clear userList to maintain history
  }
}

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(username, password);
      await StorageHelper.saveUserDetails(user);
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginScreen extends StatelessWidget {
  final controller = Get.put(LoginController());
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
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
                    child: Text('Login'),
                  )),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<Map<String, dynamic>> getUserDetails() async {
    return await StorageHelper.getUserDetails() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await StorageHelper.clearUserDetails();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: FutureBuilder
          // <Map<String, dynamic>>
          (
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          return ListView(
            children: [
              ListTile(
                title: Text(user['firstName']),
                subtitle: Text(user['email']),
                onTap: () => Get.toNamed('/details', arguments: user),
              ),
            ],
          );
        },
      ),
    );
  }
}

// class DetailsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Get.arguments;
//
//     return Scaffold(
//       appBar: AppBar(title: Text('${user['firstName']} Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${user['firstName']} ${user['lastName']}'),
//             Text('Email: ${user['email']}'),
//             Text('Phone: ${user['phone']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the User object passed via Get
    final user = Get.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.image),
              ),
            ),
            const SizedBox(height: 20),

            // Display Basic Information
            _buildDetailRow('Full Name', '${user.firstName} ${user.lastName}'),
            _buildDetailRow('Maiden Name', user.maidenName),
            _buildDetailRow('Age', user.age.toString()),
            _buildDetailRow('Gender', user.gender.name),
            _buildDetailRow('Blood Group', user.bloodGroup),
            _buildDetailRow('Eye Color', user.eyeColor),

            // Address Details
            const Divider(),
            Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Address', user.address.address),
            _buildDetailRow('City', user.address.city),
            _buildDetailRow('State', user.address.state),
            _buildDetailRow('Postal Code', user.address.postalCode),
            _buildDetailRow('Country', user.address.country.name),

            // Bank Details
            const Divider(),
            Text('Bank Details', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Card Type', user.bank.cardType),
            _buildDetailRow('Card Number', user.bank.cardNumber),
            _buildDetailRow('Card Expiry', user.bank.cardExpire),
            _buildDetailRow('Currency', user.bank.currency),
            _buildDetailRow('IBAN', user.bank.iban),

            // Company Details
            const Divider(),
            Text('Company Details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Company Name', user.company.name),
            _buildDetailRow('Department', user.company.department),
            _buildDetailRow('Title', user.company.title),

            // Contact Details
            const Divider(),
            Text('Contact Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Email', user.email),
            _buildDetailRow('Phone', user.phone),

            // Miscellaneous
            const Divider(),
            Text('Miscellaneous',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('IP Address', user.ip),
            _buildDetailRow('Mac Address', user.macAddress),
            _buildDetailRow('University', user.university),
            _buildDetailRow('User Role', user.role.name),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class AllUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Logged-in Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: StorageHelper.getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['image'] ?? ''),
                ),
                title: Text('${user['firstName']} ${user['lastName']}'),
                subtitle: Text(user['email']),
                onTap: () => Get.toNamed('/details', arguments: user),
              );
            },
          );
        },
      ),
    );
  }
}
