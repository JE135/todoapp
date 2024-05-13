import 'package:flutter/material.dart';
import '../models/todoitem.dart';
import '../models/todolist.dart';

Future<void> _showAddTodoDialog(BuildContext context) async {
  String newTodoText = "";

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add Todo"),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            newTodoText = value;
          },
          decoration: const InputDecoration(labelText: "Todo text"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newTodoItem = TodoItem(checked: false, text: newTodoText);
              addTodoItem(newTodoItem);
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

void addTodoItem(TodoItem todoItem) {
  todoList.add(todoItem);
}

void clearDoneItems() {
  todoList.removeWhere((todoItem) => todoItem.checked);
}

void clearList() {
  todoList.clear();
}
