import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/exceptions.dart';
import '../model/task_model.dart';

class Tasks extends ChangeNotifier {
  String? token;
  String? userId;

  final baseUrl = "https://pitch-todo-default-rtdb.firebaseio.com";

  Tasks(this.token, this.userId, this._taskList);
  List<TaskModel> _taskList = [];
  DateTime date = DateTime.now();

  List<TaskModel> get taskList {
    return _taskList;
  }

  Future<void> addTask({TaskModel? task}) async {
    final url = Uri.parse("$baseUrl/$userId/tasks.json?auth=$token");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": task!.title,
            "date": task.date,
            "category": task.category,
            "note": task.note,
            "isCompleted": task.isCompleted,
          },
        ),
      );
      final TaskModel newTask = TaskModel(
          id: jsonDecode(response.body)["name"],
          date: task.date,
          category: task.category,
          title: task.title,
          note: task.note,
          isCompleted: task.isCompleted);

      _taskList.add(newTask);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // get all the data from table
  Future<void> getTasks() async {
    final url = Uri.parse("$baseUrl/$userId/tasks.json?auth=$token");
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<TaskModel> loadedTasks = [];

      extractedData.forEach((taskId, task) {
        loadedTasks.add(TaskModel(
            id: taskId,
            isCompleted: task["isCompleted"],
            date: task["date"],
            category: task["category"],
            title: task["title"],
            note: task["note"]));
      });
      _taskList = loadedTasks;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // delete task from table
  Future<void> deleteTask({id}) async {
    final taskIndex = _taskList.indexWhere((element) => element.id == id);
    final url = Uri.parse("$baseUrl/$userId/tasks/$id.json?auth=$token");
    final task = _taskList[taskIndex];
    _taskList.removeAt(taskIndex);
    notifyListeners();
    getTasks();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _taskList.insert(taskIndex, task);

      notifyListeners();
      throw HttpExceptions("Could not delete product");
    }
  }

  //update Status from table
  Future<void> updateCompletedStatus({id}) async {
    final prodIndex = _taskList.indexWhere((element) => element.id == id);
    final url = Uri.parse("$baseUrl/$userId/tasks/$id.json?auth=$token");
    try {
      http.patch(
        url,
        body: jsonEncode(
          {"isCompleted": 1},
        ),
      );
      final updatedTask = _taskList[prodIndex];
      updatedTask.isCompleted = 1;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
