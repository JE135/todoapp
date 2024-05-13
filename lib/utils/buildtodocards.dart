import 'package:flutter/material.dart';
import '/models/todoitem.dart';
import '/widgets/todoitem.dart';

List<Widget> buildTodoCards(List<TodoItem> todoList) {
  List<Widget> todoCards = [];
  for (var todoItem in todoList) {
    final todoCard = TodoCard(
      todoItem: todoItem,
    );

    todoCards.add(todoCard);
  }

  return todoCards;
}
