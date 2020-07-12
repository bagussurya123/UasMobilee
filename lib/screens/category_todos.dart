import 'package:flutter/material.dart';
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/services/todo_service.dart';
import 'package:todolistapp/src/app.dart';

class CategoryToDo extends StatefulWidget {

  final String category;
  CategoryToDo({this.category});


  @override
  _CategoryToDoState createState() => _CategoryToDoState();
}

class _CategoryToDoState extends State<CategoryToDo> {

  List<ToDo> _toDoList = List<ToDo>();
  ToDoService _toDoService = ToDoService();

  @override
  initState() {
    super.initState();
    getToDosByCategory();
  }

  getToDosByCategory() async {
    var toDos = await _toDoService.readToDoByCategory(this.widget.category);
    toDos.forEach((toDo) {
      setState(() {
        var model = ToDo();
        model.id = toDo['id'];
        model.name = toDo['name'];
        model.description = toDo['description'];
        model.date = toDo['date'];
        model.category = toDo['category'];
        model.isFinished = toDo['isFinished'];

        _toDoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_toDoList[index].name ?? 'No name ')
                          ],
                        ),
                        subtitle: Text(
                          _toDoList[index].description ?? 'No category',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        trailing: Text(_toDoList[index].date ?? 'No date'),
                      ),
                    ),
                  );
              }),
          )
        ],
      ),
    );
  }
}
