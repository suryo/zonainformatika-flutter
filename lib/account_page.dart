import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zonainformatika/article_page.dart';
import 'package:zonainformatika/mylearning_page.dart';
import 'package:zonainformatika/tutor_page.dart';
import 'dart:convert';
import 'home.dart';  // Ganti dengan halaman utama Anda setelah logout
import 'login.dart';
import 'package:http/io_client.dart';
import 'dart:io';// Halaman login
import 'custom_bottom_nav_bar.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 0;
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Ambil data pengguna jika token ada
      await _fetchUserData(token);
    } else {
      // Jika tidak ada token, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Ambil data pengguna dari API
  Future<void> _fetchUserData(String token) async {
    try {
      // Prepare the request with the token in the header
      final response = await http.get(
        Uri.parse('http://192.168.6.119:8000/api/me'),  // API endpoint for user data
        headers: {
          'Authorization': 'Bearer $token',  // Sending token in Authorization header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);  // Decode the JSON response

        // Extract user data from the response and update the state
        setState(() {
          _userName = data['name'];  // Set the user name
          _userEmail = data['email'];  // Set the user email
          _isLoading = false;  // Stop the loading indicator
        });
      } else {
        // If the response is not successful (status code is not 200), redirect to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      // In case of an error, stop the loading indicator and log the error
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  // Fungsi logout
  Future<bool> logout(BuildContext context) async {
    try {
      var client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Ignore bad certificates

      var ioClient = IOClient(client);

      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        return false;
      }

      // Kirim request logout ke API
      final response = await http.post(
        Uri.parse('http://192.168.6.119:8000/api/logout'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Hapus token dan arahkan ke halaman login
          await prefs.remove('token');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account - ZonaInformatika',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $_userName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $_userEmail',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                bool success = await logout(context);
                if (success) {
                  // Logout berhasil
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Logged out successfully'),
                  ));
                } else {
                  // Gagal logout
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Logout failed'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
