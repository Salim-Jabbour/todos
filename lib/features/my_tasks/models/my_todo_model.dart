import 'package:json_annotation/json_annotation.dart';
part 'my_todo_model.g.dart';

@JsonSerializable()
class MyTodos {
  final List<MyTodoModel> todos;
  final int total;
  final int skip;
  final int limit;

  MyTodos(
      {required this.todos,
      required this.total,
      required this.skip,
      required this.limit});

  factory MyTodos.fromJson(Map<String, dynamic> json) =>
      _$MyTodosFromJson(json);

  Map<String, dynamic> toJson() => _$MyTodosToJson(this);
}

@JsonSerializable()
class MyTodoModel {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  MyTodoModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory MyTodoModel.fromJson(Map<String, dynamic> json) =>
      _$MyTodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyTodoModelToJson(this);
}
