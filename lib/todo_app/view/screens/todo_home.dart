import 'package:flutter/material.dart';
import 'package:placement_task/todo_app/global.dart';
import 'package:placement_task/todo_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';



class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProviderFalse =
    Provider.of<TodoProvider>(context, listen: false);
    TodoProvider todoProviderTrue =
    Provider.of<TodoProvider>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: todoProviderTrue.isDarkTheme
          ? ThemeData.dark()
          : ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 5,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          actions: [
            IconButton(
              onPressed: () {
                todoProviderFalse.toggleTheme();
              },
              icon: Icon(
                todoProviderTrue.isDarkTheme
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                todoProviderFalse.changeView();
              },
              icon: Icon(
                todoProviderTrue.isToggle ? Icons.grid_view : Icons.view_list,
                size: 25,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: todoProviderFalse.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: todoProviderTrue.isToggle
                    ? ListView.builder(
                  itemCount: 10, // Placeholder count
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Container(
                            height: 20,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                          subtitle: Container(
                            height: 16,
                            width: 150,
                            color: Colors.grey[300],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : GridView.builder(
                  itemCount: 12, // Placeholder count
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
              //   const Center(
              //   child: CircularProgressIndicator(),
              // );
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: todoProviderTrue.isToggle
                    ? ListView.builder(
                  itemCount: todoProviderFalse.todoList.length,
                  itemBuilder: (context, index) {
                    final todo = todoProviderFalse.todoList[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: todo.completed
                            ? Colors.green.withOpacity(0.8)
                            : Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          todo.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text('User ID: ${todo.userId}'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            '${todo.id}',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : GridView.builder(
                  itemCount: todoProviderTrue.todoList.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final todo = todoProviderTrue.todoList[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: todo.completed
                            ? Colors.green.withOpacity(0.8)
                            : Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              todo.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'User ID: ${todo.userId}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Text(
                                '${todo.id}',
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Error loading data.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}



