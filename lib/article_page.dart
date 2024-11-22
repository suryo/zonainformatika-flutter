import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zonainformatika/account_page.dart';
import 'package:zonainformatika/home.dart';
import 'package:zonainformatika/mylearning_page.dart';
import 'package:zonainformatika/tutor_page.dart';
import 'dart:convert';
import 'detail_article_page.dart';
import 'custom_bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'dart:async';


class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  int _selectedIndex = 0;
  String _timeString = '';
  String _dateString = '';
  List<dynamic> _articles = [];
  List<dynamic> _filteredArticles = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final response = await http.get(Uri.parse('http://192.168.6.119:8000/api/article'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _articles = data['articles']['data'];
        _filteredArticles = _articles;
      });
    } else {
      throw Exception('Failed to load articles');
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
    // Adjust navigation logic based on the selected index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorPage(),
        ),
      );
    }
    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyLearningPage(),
        ),
      );
    }
    else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(),
        ),
      );
    }
    else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    }
  }

  void _filterArticles(String query) {
    setState(() {
      _filteredArticles = _articles
          .where((article) =>
          article['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Articles',
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
                              _filterArticles(_searchText);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search articles...',
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = _filteredArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailArticlePage(articleId: article['id']),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://zonainformatika.com/assets/image/article/${article['image']}',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.article, size: 60, color: Colors.grey);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  article['title'] ?? '',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  article['short_desc'] ?? '',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
