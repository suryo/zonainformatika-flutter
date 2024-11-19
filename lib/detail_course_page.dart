import 'dart:convert';
import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:typed_data'; // Untuk menangani image data


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

  @override
  void initState() {
    super.initState();
    fetchCourseDetail();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchCourseDetail() async {
    final url = Uri.parse('http://zonainformatika.com/api/course/${widget.course['id']}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courseData = data['course'];
          courseDetails = data['detail'] ?? [];
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

  // Fungsi untuk mengubah base64 menjadi Uint8List
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String.split(',')[1]); // Mengambil bagian setelah 'data:image/png;base64,'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(courseData?['title'] ?? 'Course Details'),
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
                shrinkWrap: true, // Membatasi ukuran ListView agar tidak meluas
                physics: NeverScrollableScrollPhysics(), // Agar ListView tidak menggulirkan dirinya sendiri
                itemCount: courseDetails.length,
                itemBuilder: (context, index) {
                  final detail = courseDetails[index];
                  final String deltaJson = detail['text'];
                  final updatedDeltaJson = deltaJson.replaceAll('\n', '\\n');
                  final List<dynamic> delta = List.from(jsonDecode(updatedDeltaJson)['ops']);
                  final doc = quill.Document.fromJson(delta);
                  final text = doc.toPlainText();

                  // Memproses gambar dalam Delta
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
