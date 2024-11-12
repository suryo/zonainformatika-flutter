import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _todoController = TextEditingController();
  bool _completed = false;
  final int _userId = 5;

  Future<void> _addTodo() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/todos/add');

    // Convert completed to 1 for true, and 0 for false
    int completedValue = _completed ? 1 : 0;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': _todoController.text,
          'completed': completedValue,
          'userId': _userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print("Todo added: $data");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Todo added successfully!")),
        );
        Navigator.pop(context); // Go back to the previous page
      } else {
        // Handle unsuccessful status codes
        print("Failed to add todo: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add todo")),
        );
      }
    } catch (e) {
      // Catch any errors during the request
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add todo: Network error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(labelText: 'Todo'),
            ),
            Row(
              children: [
                Text('Completed'),
                Checkbox(
                  value: _completed,
                  onChanged: (value) {
                    setState(() {
                      _completed = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTodo,
              child: Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
