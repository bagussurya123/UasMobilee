import 'package:flutter/material.dart';
import 'package:todolistapp/screens/categories_screen.dart';
import 'package:todolistapp/screens/category_todos.dart';
import 'package:todolistapp/screens/done_screen.dart';
import 'package:todolistapp/screens/home_screen.dart';
import 'package:todolistapp/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryToDo(category: category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Username'),
              accountEmail: Text(
                'email@email.com',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: ExactAssetImage("assets/images/user.png"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Categories"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CategoriesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all),
              title: Text("Done"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DoneScreen()));
              },
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
