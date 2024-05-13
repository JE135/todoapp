import 'package:flutter/material.dart';
import '../models/todoitem.dart';

class TodoCard extends StatefulWidget {
  final TodoItem todoItem;

  const TodoCard({Key? key, required this.todoItem}) : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Checkbox(
              value: widget.todoItem.checked,
              onChanged: (value) {
                setState(() {
                  widget.todoItem.checked = value!;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              widget.todoItem.text,
              style: TextStyle(
                color: widget.todoItem.checked ? Colors.grey : Colors.black,
                decoration: widget.todoItem.checked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
