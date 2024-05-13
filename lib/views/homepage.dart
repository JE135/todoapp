import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<TodoItem> _todoBox;
  late List<TodoItem> todoList;

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box<TodoItem>('todos');
    todoList = _todoBox.values.toList();
  }

  void _addTodoItem(String newTodoTitle) {
    final newTodoItem = TodoItem(title: newTodoTitle, completed: false);
    setState(() {
      todoList.add(newTodoItem);
      _todoBox.add(newTodoItem); // Save to Hive
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      final removedItem = todoList.removeAt(index);
      _todoBox.delete(removedItem.key); // Remove from Hive
    });
  }

  void _toggleTodoItem(int index) {
    setState(() {
      final todoItem = todoList[index];
      todoItem.completed = !todoItem.completed;
      _todoBox.put(todoItem.key, todoItem); // Update in Hive
    });
  }

  Future<void> _promptAddTodoItem(BuildContext context) async {
    String? newTodo = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String _todoTitle = '';

        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'Todo Title'),
            onChanged: (value) {
              _todoTitle = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_todoTitle.isNotEmpty) {
                  Navigator.of(context).pop(_todoTitle);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newTodo != null && newTodo.isNotEmpty) {
      _addTodoItem(newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              _promptAddTodoItem(context);
            },
            child: Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todoItem = todoList[index];
                return ListTile(
                  leading: Checkbox(
                    value: todoItem.completed,
                    onChanged: (value) {
                      _toggleTodoItem(index);
                    },
                  ),
                  title: Text(
                    todoItem.title,
                    style: TextStyle(
                      decoration: todoItem.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeTodoItem(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  static int _nextId = 0;
  final int key;
  final String title;
  bool completed;

  TodoItem({required this.title, required this.completed}) : key = _nextId++;

  // Convert to/from Hive box
  TodoItem.fromMap(Map<String, dynamic> map)
      : key = map['key'],
        title = map['title'],
        completed = map['completed'];

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'title': title,
      'completed': completed,
    };
  }
}
