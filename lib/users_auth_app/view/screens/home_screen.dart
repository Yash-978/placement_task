import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';


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

