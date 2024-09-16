import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/providers/todos_provider.dart';
import 'package:uuid/uuid.dart'; // To generate a unique id for each todo

class AddTodoScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final uuid = Uuid(); // Generates a unique ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ensure that the title is not empty before proceeding
                if (titleController.text.isNotEmpty) {
                  // Generate a new todo with a unique id
                  final newTodo = Todo(
                    id: UniqueKey().toString(), // Generate a unique id
                    title: titleController.text,
                    date: DateTime.now(),
                    isDone: false,
                  );

                  // Add the new todo via the TodosNotifier
                  context.read<TodosNotifier>().addTodo(newTodo);

                  // Navigate back after adding the todo
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
