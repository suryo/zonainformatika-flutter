import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_course_page.dart';
import 'custom_bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'dart:async';

class Home2 extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home2> {
  int _selectedIndex = 0;
  String _timeString = '';
  String _dateString = '';
  List<dynamic> _courses = [];
  List<dynamic> _filteredCourses = [];
  String _searchText = '';

  final List<String> imageList = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final response = await http.get(Uri.parse('http://zonainformatika.com/api/course'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _courses = data['courses']['data'];
        _filteredCourses = _courses;
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _dateString = '${_getDayOfWeek(now.weekday)}, ${now.day}-${now.month}-${now.year}';
    });
  }

  String _getDayOfWeek(int day) {
    const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return daysOfWeek[day - 1];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = _courses
          .where((course) =>
          course['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'ZonaInformatika',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
        ),
        drawer: CustomDrawer(),
        backgroundColor: Color(0xFF151515),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 60.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: Duration(seconds: 3),
                ),
                items: imageList.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
              // Search bar
              Container(
                height: 150,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dateString,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white60),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _timeString,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white60),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                              _filterCourses(_searchText);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Grid view for course list
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  childAspectRatio: 3 / 2, // Adjust height
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCoursePage(course: course),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://zonainformatika.com/assets/image/course/${course['image']}',
                            height: 50,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.laptop, size: 60, color: Colors.grey);
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        // Use Flexible or Expanded here for the Text widgets
                        Flexible(
                          child: Text(
                            course['title'] ?? '',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            course['author'] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
