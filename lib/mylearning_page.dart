import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zonainformatika/account_page.dart';
import 'package:zonainformatika/article_page.dart';
import 'package:zonainformatika/home.dart';
import 'dart:convert';
import 'custom_bottom_nav_bar.dart';

import 'package:zonainformatika/login.dart';
import 'package:zonainformatika/tutor_page.dart';
import 'package:zonainformatika/detail_course_page.dart'; // Import halaman detail kursus

class MyLearningPage extends StatefulWidget {
  @override
  _MyLearningPageState createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<dynamic> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorPage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyLearningPage(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await _fetchUserData(token);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.6.119:8000/api/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userId = data['id'];
        await _fetchCourses(userId, token);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCourses(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.6.119:8000/api/member/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _courses = data[0]['courses'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Learning'),
        backgroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: _courses.isEmpty
            ? Center(
          child: Text(
            'You are not enrolled in any course. Please register first.',
            style: TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index]['course'];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(course['title']),
                subtitle: Text(course['short_desc']),
                trailing: Image.network(
                  'https://zonainformatika.com/assets/image/course/${course['image']}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailCoursePage(course: course),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
