import 'package:flutter/material.dart';
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/services/todo_service.dart';

import 'home_screen.dart';

class DoneScreen extends StatefulWidget {
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {

  ToDoService _toDoService;
  var _toDo = ToDo();

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  List<ToDo> _doneList = List<ToDo>();

  @override
  initState() {
    super.initState();
    getAllToDos();
  }

  getAllToDos() async {
    _toDoService = ToDoService();
    _doneList = List<ToDo>();

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

        if(model.isFinished != 0) {
          _doneList.add(model);
        }
      });
    });
  }

  _deleteFormDialog(BuildContext context, toDoID) {
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28.0)
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            textColor: Colors.yellowAccent,
            color: Colors.black26,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
          ),
          FlatButton(
            onPressed: () async {
              var result = await _toDoService.deleteToDo(toDoID);
              if(result > 0) {
                print(result);
                getAllToDos();
                Navigator.pop(context);
                showSuccessSnackBar('Berhasil Di hapus!');
              } else {
                showSuccessSnackBar('Tidak Berhasil dihapus! :(');
              }
            },
            child: Text('Delete'),
            textColor: Colors.black,
            color: Colors.red,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
          ),
        ],
        title: Text('Hapus item?'),
      );
    });
  }
  showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Colors.yellowAccent
        ),
      ),
      action: SnackBarAction(
          label: 'Hide',
          textColor: Colors.grey,
          onPressed: () {

          }),
      backgroundColor: Colors.black,
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    if(_doneList.length == 0) {
      return Scaffold(
        appBar: AppBar(
          leading: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Icon(Icons.home, color: Colors.black,),
            color: Colors.yellow,
          ),
          title: Text('Done'),
        ),
        body: Center(
          child: Text(
            'Items Tidak Lengkap',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Icon(Icons.home, color: Colors.black,),
            color: Colors.yellow,
          ),
          title: Text('Done'),
        ),
        body: ListView.builder(itemCount: _doneList.length, itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.undo),
                  color: Colors.yellowAccent,
                  onPressed: () async {
                    _toDo.id = _doneList[index].id;
                    print(_toDo.id);
                    _toDo.name = _doneList[index].name;
                    _toDo.description = _doneList[index].description;
                    _toDo.date = _doneList[index].date;
                    _toDo.category = _doneList[index].category;
                    _toDo.isFinished = 0;
                    var result = await _toDoService.updateToDo(_toDo);
                    if(result > 0) {
                      print(result);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DoneScreen()));
                    }
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_doneList[index].name ?? 'Tidak Ada name ')
                  ],
                ),
                subtitle: Text(
                  _doneList[index].category ?? 'Tidak Ada category',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_sweep),
                  color: Colors.red,
                  onPressed: () async {
                    _deleteFormDialog(context, _doneList[index].id);
                  },
                ),
              ),
            ),
          );
        }),
      );
    }

  }
}
