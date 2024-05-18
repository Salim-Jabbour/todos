// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyTodos _$MyTodosFromJson(Map<String, dynamic> json) => MyTodos(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => MyTodoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$MyTodosToJson(MyTodos instance) => <String, dynamic>{
      'todos': instance.todos,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

MyTodoModel _$MyTodoModelFromJson(Map<String, dynamic> json) => MyTodoModel(
      id: (json['id'] as num).toInt(),
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$MyTodoModelToJson(MyTodoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'todo': instance.todo,
      'completed': instance.completed,
      'userId': instance.userId,
    };
