import 'all_todos_injection.dart';
import 'auth_injection.dart';
import 'dio_init_client.dart';
import 'global_injection.dart';
import 'my_todo_injection.dart';
import 'profile_injection.dart';

Future<void> initInjection() async {
  await dioInjection();
  await globalInjection();
  await authInjection();
  await myTodoInjection();
  await profileInjection();
  await allTodoInjection();
}
