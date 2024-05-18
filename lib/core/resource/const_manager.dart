import 'package:flutter/material.dart';

import '../../features/my_tasks/presentation/pages/add_todo_page.dart';
import '../../features/my_tasks/presentation/pages/my_todos_page.dart';
import '../widgets/empty_widget.dart';

class ConstManager {
  static String baseUrl = 'https://dummyjson.com';
  static final List<Widget> pageOptions = [
    const MyTodosPage(),
    const AddTodoPage(),
    const EmptyWidget(height: 10),
  ];
}
