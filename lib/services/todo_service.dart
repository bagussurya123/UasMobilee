import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/repositories/repository.dart';

class ToDoService {
  Repository _repository;

  ToDoService() {
    _repository = Repository();
  }

  saveToDo(ToDo toDo) async {
    return await _repository.insertData('todos', toDo.toDoMap());
  }

  readToDo() async {
    return await _repository.readData('todos');
  }
  
  readToDoByCategory(category) async {
    return await _repository.readDataByColumnName('todos', 'category', category);
  }
  updateToDo(ToDo toDo) async {
    return await _repository.updateData('todos', toDo.toDoMap());
  }

  deleteToDo(toDoID) async {
    return await _repository.deleteData('todos', toDoID);
  }
}