import 'package:flutter/material.dart';
import 'package:todo_app/database/sqf.dart';
import 'package:todo_app/model/todo.dart';


class TodosNotifier extends ChangeNotifier {
  List<Todo> todos = [];
  bool isLoading = true;
  String errorMessage = '';

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> fetchTodos() async {
    try {
      isLoading = true;
      List<Todo> fetchedTodos = await _dbHelper.fetchTodos();
      todos = fetchedTodos;
      errorMessage = '';
      isLoading = false;
    } catch (error) {
      errorMessage = 'Error fetching todos: $error';
      isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await _dbHelper.insertTodo(todo);
      todos.add(todo);
      notifyListeners();
    } catch (error) {
      errorMessage = 'Error adding todo: $error';
      notifyListeners();
    }
  }

  Future<void> editTodo(Todo updatedTodo) async {
    try {
      isLoading = true;
      notifyListeners();

      await _dbHelper.updateTodo(updatedTodo);

      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
      }

      isLoading = false;
    } catch (error) {
      errorMessage = 'Error editing todo: $error';
      isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      await _dbHelper.deleteTodo(id);
      todos.removeWhere((todo) => todo.id == id);

      isLoading = false;
    } catch (error) {
      errorMessage = 'Error deleting todo: $error';
      isLoading = false;
    } finally {
      notifyListeners();
    }
  }
}
