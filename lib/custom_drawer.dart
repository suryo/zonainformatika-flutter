import 'package:flutter/material.dart';
import 'tentangkami.dart';
import 'list_todo_page.dart';
import 'add_todo_page.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Container(
        color: Colors.white, // Set drawer background color to black
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'List Todo',
                style: TextStyle(color: Colors.black87), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListTodoPage(data: 'test'),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Add Todo',
                style: TextStyle(color: Colors.black87), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Go to Tentang Kami',
                style: TextStyle(color: Colors.black87), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Tentangkami(data: 'Hello from Tentang Kami'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
