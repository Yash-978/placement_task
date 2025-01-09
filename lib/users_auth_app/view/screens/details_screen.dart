import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../services/services.dart';


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