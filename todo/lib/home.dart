import 'package:flutter/material.dart';
import 'model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todoList = [];
  List<Todo> done = [];
  Todo? deletedCache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReorderableTodo"),
        actions: [Text("${todoList.length}")],
      ),
      floatingActionButton: _addTodo(context),
      body: _body(),
    );
  }

  ReorderableListView _body() {
    return ReorderableListView(
      onReorder: (start, end) {
        var temp = todoList[start];
        setState(() {
          todoList[start] = todoList[end];
          todoList[end] = temp;
        });
      },
      children: [
        for (Todo todo in todoList)
          Dismissible(
              key: ValueKey(todo),
              onDismissed: (direction) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                setState(() {
                  deletedCache = todo;
                  todoList.removeAt(todoList.indexOf(todo));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: GestureDetector(
                          onTap: () {
                            setState(() {
                              todoList.insert(
                                  deletedCache!.index, deletedCache!);
                              deletedCache = null;
                            });
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Text("Undo Delete?"))));
                });
              },
              background: ListTile(
                  tileColor: Colors.orange,
                  leading: Icon(Icons.archive, color: Colors.white, size: 28)),
              secondaryBackground: ListTile(
                tileColor: Colors.red,
                trailing: Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                child: Card(
                  key: ValueKey(todo),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        todo.markDone();
                        if (todo.done)
                          Future.delayed(Duration(seconds: 2), () {
                            done.add(todo);
                            todoList.removeAt(todoList.indexOf(todo));
                          });
                      });
                    },
                    leading: Checkbox(
                      onChanged: (bool? value) {
                        setState(() {
                          todo.markDone();
                          if (todo.done)
                            Future.delayed(Duration(seconds: 2), () {
                              done.add(todo);
                              todoList.removeAt(todoList.indexOf(todo));
                            });
                        });
                        if (value == true) {}
                      },
                      value: todo.done,
                    ),
                    title: Text(
                      todo.content,
                      style: TextStyle(
                        decoration: todo.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ))
      ],
    );
  }

  FloatingActionButton _addTodo(BuildContext context) {
    return FloatingActionButton.extended(
        label: Text("Add"),
        icon: Icon(Icons.add),
        shape: StadiumBorder(),
        onPressed: add);
  }

  add() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Todo? todo;
          return SimpleDialog(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(onChanged: (String val) {
                    setState(() {
                      todo = Todo(val, todoList.length);
                    });
                  })),
              Center(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          todo != null
                              ? todoList.add(todo!)
                              : Navigator.pop(context);
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add todo")))
            ],
          );
        });
  }
}
