import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zonainformatika/mylearning_page.dart';
import 'package:url_launcher/url_launcher.dart';

// Pastikan Anda mengganti nama-nama halaman dengan kelas yang benar
import 'home.dart';
import 'mylearning_page.dart';
import 'article_page.dart';
import 'account_page.dart';
import 'custom_bottom_nav_bar.dart';
import 'navigation_helper.dart'; // Import file navigasi baru


class TutorPage extends StatefulWidget {
  @override
  _TutorPageState createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    onItemTapped(context, index); // Panggil fungsi global
  }
  Future<List<Map<String, dynamic>>> fetchTutors() async {
    final url = Uri.parse('http://192.168.6.119:8000/api/tutors');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> tutors = jsonResponse['data'];
      return tutors.map((tutor) {
        return {
          "name": tutor['name'] ?? 'No Name',
          "email": tutor['email'] ?? 'No Email',
          "phone": tutor['phone'] ?? 'No Phone',
        };
      }).toList();
    } else {
      throw Exception('Failed to load tutors');
    }
  }

  void _contactTutor(String phoneNumber) async {
    final whatsappUrl = Uri.parse('https://wa.me/6285649224822');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication, // Membuka WhatsApp di aplikasi eksternal
      );
    } else {
      // Tampilkan pesan jika WhatsApp tidak bisa dibuka
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open WhatsApp. Please check the phone number.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutors' , style: TextStyle(color: Colors.white, fontSize: 18),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF151515),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchTutors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No tutors found'),
              );
            } else {
              final tutors = snapshot.data!;
              return ListView.builder(
                itemCount: tutors.length,
                itemBuilder: (context, index) {
                  final tutor = tutors[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutor['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ${tutor['email']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Phone: ${tutor['phone']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (tutor['phone'] != 'No Phone') {
                                _contactTutor(tutor['phone']);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Phone number not available'),
                                  ),
                                );
                              }
                            },
                            child: Text('Contact Tutor'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
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

