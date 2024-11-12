import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailTodoPage extends StatefulWidget {
  final int todoId;

  DetailTodoPage({required this.todoId});

  @override
  _DetailTodoPageState createState() => _DetailTodoPageState();
}

class _DetailTodoPageState extends State<DetailTodoPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _todoDetails;

  @override
  void initState() {
    super.initState();
    _fetchTodoDetails();
  }

  // Fetch todo details from the API
  Future<void> _fetchTodoDetails() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/todos/${widget.todoId}'));

    if (response.statusCode == 200) {
      setState(() {
        _todoDetails = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load todo details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      // backgroundColor: Color(0xFF2C1B7D),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _todoDetails == null
          ? Center(child: Text('No details available'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo ID: ${_todoDetails!['id']}',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Task: ${_todoDetails!['title']}',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Completed: ${_todoDetails!['completed'] ? "Yes" : "No"}',
              style: TextStyle(
                color: _todoDetails!['completed'] ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'User ID: ${_todoDetails!['userId']}',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
