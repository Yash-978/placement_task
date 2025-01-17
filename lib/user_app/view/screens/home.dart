// import 'package:concentric_transition/page_view.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:placement_task/user_app/controller/controller.dart';
//
// CustomerController customerController = Get.put(CustomerController());
// bool _toastShownOnline = false; // Flag for online toast
// bool _toastShownOffline = false; // Flag for offline toast
//
// class UserHomePage extends StatelessWidget {
//   // final CustomerController customerController = Get.find(); // Assuming GetX for state management
//
//   UserHomePage({super.key});
//
//   void checkInternetConnection(BuildContext context) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("No Internet Connection"),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Check internet connection initially
//     checkInternetConnection(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'User App',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder(
//         stream: Connectivity().onConnectivityChanged,
//         builder: (context, snapshot) {
//           if (snapshot.data == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.data!.contains(ConnectivityResult.mobile) ||
//               snapshot.data!.contains(ConnectivityResult.wifi)) {
//             if (!_toastShownOnline) {
//               Fluttertoast.showToast(
//                   msg: 'Data not found', backgroundColor: Colors.red);
//               _toastShownOffline = false;
//               _toastShownOnline = true;
//             }
//           }
//           return FutureBuilder(
//             future: customerController.fetchData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Colors.teal),
//                 );
//               } else if (snapshot.hasError) {
//                 return Center(
//                   child: Text(
//                     "Error fetching data: ${snapshot.error}",
//                     style: const TextStyle(fontSize: 16, color: Colors.red),
//                   ),
//                 );
//               }
//               return ConcentricPageView(
//                 direction: Axis.vertical,
//                 radius: 250,
//                 colors: const [
//                   Colors.greenAccent,
//                   Colors.blue,
//                   Colors.orange,
//                   Colors.purpleAccent,
//                   Colors.cyan,
//                 ],
//                 itemCount: customerController.customerList.length,
//                 itemBuilder: (index) {
//                   final customer = customerController.customerList[index];
//                   return Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           spreadRadius: 5,
//                         )
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage: NetworkImage(customer.avatar),
//                           backgroundColor: Colors.white,
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           customer.name,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           customer.email,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "Role: ${customer.role.name}",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "ID: ${customer.id}",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           "Created At: ${customer.creationAt}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           "Updated At: ${customer.updatedAt}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => checkInternetConnection(context),
//         backgroundColor: Colors.teal,
//         child: const Icon(Icons.wifi),
//       ),
//     );
//   }
// }
//
// /*ListView.builder(
//             itemCount: customerController.customerList.length,
//             itemBuilder: (context, index) {
//               final customer = customerController.customerList[index];
//               return Container(
//
//                 child: Column(
//                   children: [
//
//
//                 Container(
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(customer.avatar),
//                         ),
//                       ),
//                     ),
//                     Text(customer.email),
//                     Text(customer.name),
//                     Text(customer.password),
//                     // Text(customer.creationAt.timeZoneName.removeAllWhitespace),
//                     Text(customer.id.toString()),
//                     Text(customer.role.name),
//
//                   ],
//                 ),
//               );
//             },
//           );*/
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../controller/controller.dart';
import '../../modal/modal.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.deepPurple,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        labelStyle: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: Colors.deepPurple,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.purple[50],
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  bool _toastShownOnline = false; // Flag for online toast
  bool _toastShownOffline = false; // Flag for offline toast

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'User App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.contains(ConnectivityResult.mobile) ||
              snapshot.data!.contains(ConnectivityResult.wifi)) {
            if (!_toastShownOnline) {
              Fluttertoast.showToast(
                msg: "You are online. Data restored.",
                backgroundColor: Colors.deepOrange,
                textColor: Colors.white,
              );
              _toastShownOnline = true;
              _toastShownOffline = false;
            }
            return _buildUserList(userProvider);
          } else {
            if (!_toastShownOffline) {
              Fluttertoast.showToast(
                msg: "You are offline. Showing saved data.",
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              _toastShownOffline = true;
              _toastShownOnline = false;
            }
            return _buildOfflineUserList(userProvider);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await userProvider.fetchData();
          setState(() {});
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.sync, color: Colors.white),
      ),
    );
  }

  Widget _buildUserList(UsersProvider userProvider) {
    return FutureBuilder(
      future: userProvider.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: userProvider.usersModal.length,
          itemBuilder: (context, index) {
            UsersModal user = userProvider.usersModal[index];
            return _buildUserCard(user);
          },
        );
      },
    );
  }

  Widget _buildOfflineUserList(UsersProvider userProvider) {
    return FutureBuilder(
      future: userProvider.readDataFromDb(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final users = snapshot.data as List<DatabaseUsers>;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user);
          },
        );
      },
    );
  }

  Widget _buildUserCard(dynamic user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(

          radius: 30,
          backgroundImage: NetworkImage(user.avatar),

          backgroundColor: Colors.deepPurple.withOpacity(0.2),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Text(
          "Email: ${user.email}\nRole: ${user.role}",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          onPressed: () {
            // Update logic
          },
          icon: const Icon(Icons.edit, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
