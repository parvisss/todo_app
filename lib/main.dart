import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/sqf.dart';
import 'package:todo_app/providers/todos_provider.dart';
import 'package:todo_app/screens/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodosNotifier()..fetchTodos(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text('Todo App')),
          body: const TodosScreen(),
        ),
      ),
    );
  }
}
