class ToDo {
  int id;
  String name;
  String description;
  String date;
  String category;
  int isFinished;

  toDoMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['date'] = date;
    map['category'] = category;
    map['isFinished'] = isFinished;
    return map;
  }
}