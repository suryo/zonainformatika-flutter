import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'custom_bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'detail_todo_page.dart';

class ListTodoPage extends StatefulWidget {
  final String data;

  ListTodoPage({required this.data});

  @override
  _ListTodoPageState createState() => _ListTodoPageState();
}

class _ListTodoPageState extends State<ListTodoPage> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  List<dynamic> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/todos'));

    if (response.statusCode == 200) {
      setState(() {
        _todos = json.decode(response.body)['todos'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load todos');
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (index == 2) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Settings tapped"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigate to DetailTodoPage with the selected todo ID
  void _navigateToDetail(int todoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTodoPage(todoId: todoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      // backgroundColor: Color(0xFF2C1B7D),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return GestureDetector(
            onTap: () => _navigateToDetail(todo['id']),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todo ${todo['id']}: ${todo['todo']}',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Completed: ${todo['completed'] ? "Yes" : "No"}',
                    style: TextStyle(
                      color: todo['completed'] ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
