import 'package:flutter/material.dart';
import 'package:flutter_todos/widgets/header.dart';
import 'package:flutter_todos/widgets/task_input.dart';
import 'package:flutter_todos/widgets/todo.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/model/db_wrapper.dart';
import 'package:flutter_todos/utils/utils.dart';

void main() => runApp(TodosApp());

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        // backgroundColor: Color(0xfffff5eb),
      ),
      title: "TODO",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String welcomeMsg;
  List<Model.Todo> todos;

  @override
  void initState() {
    super.initState();
    getTodosAndDones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Utils.hideKeyboard(context);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Header(
                                      msg: "TODO APP",
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TaskInput(
                                  onSubmitted: addTaskInTodo,
                                ), // Add Todos
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    switch (index) {
                      case 0:
                        return Todo(
                          todos: todos,
                          onTap: markTodoAsDone,
                          onDeleteTask: (){},
                        ); // Active todos
                      default:
                        return SizedBox(
                          height: 30,
                        );// Done todos
                    }
                  },
                  childCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getTodosAndDones() async {
    final _todos = await DBWrapper.sharedInstance.getTodos();
    setState(() {
      todos = _todos;
    });
  }

  void addTaskInTodo({@required TextEditingController controller}) {
    final inputText = controller.text.trim();

    if (inputText.length > 0) {
      // Add todos
      Model.Todo todo = Model.Todo(
        title: inputText,
        created: DateTime.now(),
        updated: DateTime.now(),
        status: Model.TodoStatus.active.index,
      );

      DBWrapper.sharedInstance.addTodo(todo);
      getTodosAndDones();
    } else {
      Utils.hideKeyboard(context);
    }

    controller.text = '';
  }

  void markTodoAsDone({@required int pos}) {
    if(todos[pos].status==1){
      DBWrapper.sharedInstance.markDoneAsTodo(todos[pos]);
    }else{
      DBWrapper.sharedInstance.markTodoAsDone(todos[pos]);
    }
    getTodosAndDones();
  }


}
