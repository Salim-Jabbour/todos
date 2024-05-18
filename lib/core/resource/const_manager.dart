import 'package:flutter/material.dart';

import '../../features/all_todos/presentation/page/all_todos_page.dart';
import '../../features/my_tasks/presentation/pages/add_todo_page.dart';
import '../../features/my_tasks/presentation/pages/my_todos_page.dart';

class ConstManager {
  static String baseUrl = 'https://dummyjson.com';
  static final List<Widget> pageOptions = [
    const MyTodosPage(),
    const AddTodoPage(),
    const AllTodosPage(),
  ];
}
