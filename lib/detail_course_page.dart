import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonainformatika/account_page.dart';
import 'package:zonainformatika/article_page.dart';
import 'package:zonainformatika/home.dart';
import 'package:zonainformatika/login.dart';
// import 'package:zonainformatika/login_page.dart';
import 'package:zonainformatika/mylearning_page.dart';
import 'package:zonainformatika/tutor_page.dart';
import 'custom_bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DetailCoursePage extends StatefulWidget {
  final Map<String, dynamic> course;

  DetailCoursePage({required this.course});

  @override
  _DetailCoursePageState createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? courseData;
  List<dynamic> courseDetails = [];
  bool isLoading = true;
  bool availabilityOnRegister = false;
  String? userToken;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      userToken = token;
      fetchCourseDetail();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TutorPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyLearningPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
    }
  }

  Future<void> fetchCourseDetail() async {
    if (userToken == null) return;

    final url = Uri.parse('http://192.168.6.119:8000/api/showcourse/${widget.course['id']}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $userToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courseData = data['course'];
          courseDetails = data['course_details'] ?? [];
          availabilityOnRegister = data['availability_on_register'] == 0;
          isLoading = false;
        });
      } else {
        print('Failed to load course detail');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerForCourse() async {
    if (userToken == null) return;

    final url = Uri.parse('http://192.168.6.119:8000/api/course/${widget.course['id']}/register');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $userToken'},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['message'] == 'You have successfully registered for the course.') {
          // Show success message and registration details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          print('Registration Details: ${responseData['registration']}');
        }
      } else if (responseData['message'] == 'You are already registered for this course.') {
        // Show message if already registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register Done')),
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Navigasi ke Home.dart
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String.split(',')[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ZonaInformatika',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : availabilityOnRegister
          ? Center(
        child: ElevatedButton(
          onPressed: registerForCourse,
          child: Text('Register for Course'),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                courseData?['title'] ?? 'Course Title',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                courseData?['author'] ?? 'Author',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Text(
                courseData?['short_desc'] ?? 'No description available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                courseData?['text'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Text(
                'Course Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: courseDetails.length,
                itemBuilder: (context, index) {
                  final detail = courseDetails[index];
                  final String deltaJson = detail['text'];
                  final updatedDeltaJson = deltaJson.replaceAll('\n', '\\n');
                  final List<dynamic> delta = List.from(jsonDecode(updatedDeltaJson)['ops']);
                  final doc = quill.Document.fromJson(delta);
                  final text = doc.toPlainText();

                  List<Widget> richTextWidgets = [];
                  for (var op in jsonDecode(updatedDeltaJson)['ops']) {
                    if (op['insert'] is String) {
                      richTextWidgets.add(Text(op['insert']));
                    } else if (op['insert']['image'] != null) {
                      final imageData = op['insert']['image'];
                      final imageBytes = decodeBase64Image(imageData);
                      richTextWidgets.add(
                        Image.memory(
                          imageBytes,
                          height: 150,
                          width: 150,
                        ),
                      );
                    }
                  }

                  return ExpansionTile(
                    title: Text(detail['title'] ?? 'Detail Title'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: richTextWidgets.map((widget) {
                                if (widget is Text) {
                                  return Text(
                                    widget.data ?? '',
                                    style: widget.style,
                                    textAlign: TextAlign.justify,
                                  );
                                }
                                return widget;
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
