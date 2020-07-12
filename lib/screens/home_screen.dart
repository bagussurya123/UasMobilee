import 'package:flutter/material.dart';
import 'package:todolistapp/helpers/drawer_navigation.dart';
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/screens/todo_screen.dart';
import 'package:todolistapp/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ToDoService _toDoService;
  var _toDo = ToDo();

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  List<ToDo> _toDoList = List<ToDo>();

  @override
  initState() {
    super.initState();
    getAllToDos();
  }

  getAllToDos() async {
    _toDoService = ToDoService();
    _toDoList = List<ToDo>();

    var toDos = await _toDoService.readToDo();
    toDos.forEach((toDo) {
      setState(() {
        var model = ToDo();
        model.id = toDo['id'];
        model.name = toDo['name'];
        model.description = toDo['description'];
        model.date = toDo['date'];
        model.category = toDo['category'];
        model.isFinished = toDo['isFinished'];

        if (model.isFinished == 0) {
          _toDoList.add(model);
        }
      });
    });
  }

  _deleteFormDialog(BuildContext context, toDoID) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28.0)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
                textColor: Colors.blueAccent,
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              FlatButton(
                onPressed: () async {
                  var result = await _toDoService.deleteToDo(toDoID);
                  if (result > 0) {
                    print(result);
                    getAllToDos();
                    Navigator.pop(context);
                    showSuccessSnackBar('Data berhasil di hapus!');
                  } else {
                    showSuccessSnackBar('Data gagal dihapus :(');
                  }
                },
                child: Text('Delete'),
                textColor: Colors.black,
                color: Colors.red,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ],
            title: Text('Hapus Data?'),
          );
        });
  }

  showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.yellowAccent),
      ),
      action: SnackBarAction(
          label: 'Hide', textColor: Colors.grey, onPressed: () {}),
      backgroundColor: Colors.black,
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    if (_toDoList.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        drawer: DrawerNavigation(),
        body: Center(
          child: Text(
            'Tidak Ada Item',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TodoScreen()));
          },
          child: Icon(Icons.add),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(28.0)),
        ),
      );
    }
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          'List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
          itemCount: _toDoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.done),
                    color: Colors.blueAccent,
                    onPressed: () async {
                      _toDo.id = _toDoList[index].id;
                      print(_toDo.id);
                      _toDo.name = _toDoList[index].name;
                      _toDo.description = _toDoList[index].description;
                      _toDo.date = _toDoList[index].date;
                      _toDo.category = _toDoList[index].category;
                      _toDo.isFinished = 1;
                      var result = await _toDoService.updateToDo(_toDo);
                      if (result > 0) {
                        print(result);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      }
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_toDoList[index].name ?? 'Tidak Ada Nama ')
                    ],
                  ),
                  subtitle: Text(
                    _toDoList[index].category ?? 'Tidak ada category',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_sweep),
                    color: Colors.red,
                    onPressed: () async {
                      _deleteFormDialog(context, _toDoList[index].id);
                    },
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28.0)),
      ),
    );
  }
}
