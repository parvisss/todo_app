import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/providers/todos_provider.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;

  EditTodoScreen({super.key, required this.todo});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize the text fields with the current values
    _titleController.text = todo.title;
    _dateController.text = todo.date.toIso8601String(); // Using ISO format

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            // Date input field
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              readOnly: true, // Prevent manual editing of the date
              onTap: () async {
                // Open a date picker
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: todo.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text = pickedDate.toIso8601String(); // Format the date
                }
              },
            ),
            const SizedBox(height: 20),
            // Button to update the todo
            ElevatedButton(
              onPressed: () {
                // Create an updated Todo object
                Todo updatedTodo = Todo(
                  id: todo.id, // Keep the original ID
                  title: _titleController.text,
                  date: DateTime.parse(_dateController.text), // Parse the selected date
                  isDone: todo.isDone, // Keep the original done status
                );

                // Update the todo in the provider
                context.read<TodosNotifier>().editTodo(updatedTodo);

                // Navigate back after saving the changes
                Navigator.of(context).pop();
              },
              child: const Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
