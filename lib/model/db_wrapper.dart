import 'package:flutter_todos/model/model.dart';
import 'package:flutter_todos/model/db.dart';

class DBWrapper {
  static final DBWrapper sharedInstance = DBWrapper._();

  DBWrapper._();


  Future<List<Todo>> getTodos() async {
    List list = await DB.sharedInstance.retrieveTodos();
    return list;
  }

  void addTodo(Todo todo) async {
    await DB.sharedInstance.createTodo(todo);
  }

  void markTodoAsDone(Todo todo) async {
    todo.status = TodoStatus.done.index;
    todo.updated = DateTime.now();
    await DB.sharedInstance.updateTodo(todo);
  }

  void markDoneAsTodo(Todo todo) async {
    todo.status = TodoStatus.active.index;
    todo.updated = DateTime.now();
    await DB.sharedInstance.updateTodo(todo);
  }


}
