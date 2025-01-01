import 'package:flutter/material.dart';


const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color primaryClr = Color(0xff4e5ae8);
const Color darkGreyClr = Color(0xff121212);
const Color darkHeaderClr = Color(0xff424242);
const Color lightGreenClr = Color(0xffC3F6BC);
const Color lightYellowClr = Color(0xffFFE9A6);



// Widget build(BuildContext context) {
//   TodoProvider todoProviderFalse =
//       Provider.of<TodoProvider>(context, listen: false);
//   TodoProvider todoProviderTrue =
//       Provider.of<TodoProvider>(context, listen: true);
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('HomePage'),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: IconButton(
//               onPressed: () {
//                 todoProviderFalse.changeView();
//               },
//               icon: Icon(
//                 todoProviderTrue.isToggle ? Icons.grid_3x3 : Icons.list,
//                 size: 25,
//               )),
//         )
//       ],
//     ),
//     body: FutureBuilder(
//       future: todoProviderFalse.fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: todoProviderTrue.isToggle
//                 ? ListView.builder(
//                     itemCount: todoProviderFalse.todoList.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.teal,
//                         child: ListTile(
//                           title: Column(
//                             children: [
//                               Text(todoProviderFalse.todoList[index].title
//                                   .toString()),
//                               Text(todoProviderFalse.todoList[index].userId
//                                   .toString()),
//                             ],
//                           ),
//                           leading: Text(todoProviderFalse.todoList[index].id
//                               .toString()),
//                           trailing: Text(todoProviderFalse
//                               .todoList[index].userId
//                               .toString()),
//                         ),
//                       );
//                     },
//                   )
//                 : GridView.builder(
//                     itemCount: todoProviderTrue.todoList.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2),
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.teal,
//                         child: ListTile(
//                           title: Column(
//                             children: [
//                               Text(todoProviderFalse.todoList[index].title
//                                   .toString()),
//                               Text(todoProviderFalse.todoList[index].userId
//                                   .toString()),
//                             ],
//                           ),
//                           leading: Text(todoProviderFalse.todoList[index].id
//                               .toString()),
//                           trailing: Text(todoProviderFalse
//                               .todoList[index].userId
//                               .toString()),
//                         ),
//                       );
//                     },
//                   ),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     ),
//   );
// }