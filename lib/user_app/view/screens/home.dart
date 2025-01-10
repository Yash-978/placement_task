import 'package:concentric_transition/page_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_task/user_app/controller/controller.dart';

CustomerController customerController = Get.put(CustomerController());

// class UserHomePage extends StatelessWidget {
//   const UserHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User app'),
//       ),
//       body:
//       FutureBuilder(
//         future: customerController.fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ConcentricPageView(
//             direction: Axis.vertical,
//             radius: 250,
//             colors: const [
//               Colors.greenAccent,
//               Colors.blue,
//               Colors.orange
//               // Color(0xffB2EDFD),
//               // Color(0xffC3F6BC),
//               // Color(0xffFFE9A6),
//               // Color(0xffDBCCFD),
//             ],
//             itemCount: customerController.customerList.length,
//             itemBuilder: (index) {
//               final customer = customerController.customerList[index];
//               return Container(
//                 child: Column(
//                   children: [
//                     Container(
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
//                     // Text(customer.creationAt),
//                     Text(customer.id.toString()),
//                     Text(customer.role.name),
//                   ],
//                 ),
//               );
//             },
//           );
//
//
//         },
//       ),
//     );
//   }
// }


class UserHomePage extends StatelessWidget {
  // final CustomerController customerController = Get.find(); // Assuming GetX for state management

  UserHomePage({super.key});

  void checkInternetConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Internet Connection"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check internet connection initially
    checkInternetConnection(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User App',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: customerController.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching data: ${snapshot.error}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          return ConcentricPageView(
            direction: Axis.vertical,
            radius: 250,
            colors: const [
              Colors.greenAccent,
              Colors.blue,
              Colors.orange,
              Colors.purpleAccent,
              Colors.cyan,
            ],
            itemCount: customerController.customerList.length,
            itemBuilder: (index) {
              final customer = customerController.customerList[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(customer.avatar),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      customer.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Role: ${customer.role.name}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "ID: ${customer.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Created At: ${customer.creationAt}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Updated At: ${customer.updatedAt}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => checkInternetConnection(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.wifi),
      ),
    );
  }
}


/*ListView.builder(
            itemCount: customerController.customerList.length,
            itemBuilder: (context, index) {
              final customer = customerController.customerList[index];
              return Container(

                child: Column(
                  children: [


                Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(customer.avatar),
                        ),
                      ),
                    ),
                    Text(customer.email),
                    Text(customer.name),
                    Text(customer.password),
                    // Text(customer.creationAt.timeZoneName.removeAllWhitespace),
                    Text(customer.id.toString()),
                    Text(customer.role.name),

                  ],
                ),
              );
            },
          );*/