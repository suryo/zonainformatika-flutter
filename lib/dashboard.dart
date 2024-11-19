import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'home.dart';

class DashboardPage extends StatelessWidget {

  // Fungsi untuk logout ke API
  Future<bool> logout(BuildContext context) async {
    try {
      var client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Ignore bad certificates

      var ioClient = IOClient(client);

      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(prefs.getString('token'));
      if (token == null) {
        print('No token found!');
        return false;
      }

      // Kirim request logout ke API
      final response = await http.post(
        Uri.parse('http://192.168.6.119:8000/api/logout'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Header untuk raw JSON
        },
        body: json.encode({'token': token}),
      );
      print(json.encode({'token': token}));
      print(json.decode(response.body));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['success'] == true) {
          // Jika logout berhasil, hapus token
          await prefs.remove('token');
          print('User logged out successfully');

          // Arahkan ke halaman Home setelah logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Ganti HomePage() dengan halaman utama Anda
          );
          return true;
        } else {
          print('Logout failed');
          return false;
        }
      } else {
        print('Failed to logout. Status Code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard - ZonaInformatika',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black87),
                child: Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Aksi untuk menu Home
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Aksi untuk menu Settings
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Signout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Panggil fungsi logout ketika tombol logout ditekan
                  logout(context);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF151515),
        body: Center(
          child: Text(
            'Welcome to Dashboard!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Colors.black87,
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to Home Page!',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
