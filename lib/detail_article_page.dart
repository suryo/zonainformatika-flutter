import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zonainformatika/account_page.dart';
import 'package:zonainformatika/article_page.dart';
import 'package:zonainformatika/home.dart';
import 'package:zonainformatika/mylearning_page.dart';
import 'package:zonainformatika/tutor_page.dart';
import 'custom_bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:typed_data'; // Untuk menangani image data

class DetailArticlePage extends StatefulWidget {
  final int articleId;

  DetailArticlePage({required this.articleId});

  @override
  _DetailArticlePageState createState() => _DetailArticlePageState();
}

class _DetailArticlePageState extends State<DetailArticlePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? articleData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticleDetail();
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


  Future<void> fetchArticleDetail() async {
    final url = Uri.parse('http://192.168.6.119:8000/api/article/${widget.articleId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articleData = data['article'];
          isLoading = false;
        });
      } else {
        print('Failed to load article detail');
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

  // Fungsi untuk mengubah base64 menjadi Uint8List
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String.split(',')[1]); // Mengambil bagian setelah 'data:image/png;base64,'
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
          : SingleChildScrollView(  // Membungkus semua konten dalam SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                articleData?['title'] ?? 'Article Title',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                articleData?['short_desc'] ?? 'Short description not available.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Text(
                'Content:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildRichTextContent(articleData?['text']),
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

  // Fungsi untuk membangun konten rich text dari Quill Delta
  Widget _buildRichTextContent(String deltaJson) {
    try {
      // Mengganti newline (\n) menjadi '\\n' untuk menghindari kesalahan parsing JSON
      final updatedDeltaJson = deltaJson.replaceAll('\n', '\\n');
      final List<dynamic> delta = List.from(jsonDecode(updatedDeltaJson)['ops']);
      final doc = quill.Document.fromJson(delta);
      final text = doc.toPlainText();

      List<Widget> richTextWidgets = [];
      for (var op in jsonDecode(updatedDeltaJson)['ops']) {
        if (op['insert'] is String) {
          // Menambahkan teks biasa
          richTextWidgets.add(Text(op['insert']));
        } else if (op['insert']['image'] != null) {
          // Menambahkan gambar
          final imageData = op['insert']['image'];
          final imageBytes = decodeBase64Image(imageData);
          richTextWidgets.add(
            Image.memory(
              imageBytes,
              height: 150, // Menyesuaikan ukuran gambar
              width: 150, // Menyesuaikan ukuran gambar
            ),
          );
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: richTextWidgets,
      );
    } catch (e) {
      print('Error parsing rich text content: $e');
      return Text('Failed to load content.');
    }
  }
}
