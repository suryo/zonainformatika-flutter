import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class AuthService {
  final String baseUrl = 'http://192.168.6.119:8000/api'; // URL API Laravel Anda

  Future<bool> login(String email, String password) async {
    print("email: $email");
    print("password: $password");

    try {

      var client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Ignore bad certificates

      var ioClient = IOClient(client);

      // Persiapkan body dalam format raw JSON
      final body = json.encode({
        'email': email,
        'password': password,
      });

      // Kirim POST request dengan header dan body raw JSON
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Header untuk raw JSON
        },
        body: body,
      );

      // Debugging response
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final token = data['token']; // Ambil token dari response

          // Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          print("Login berhasil untuk: ${data['name']} (${data['email']})");
          print(prefs.getString('token'));
          return true;
        } else {
          print("Login gagal: ${data['message'] ?? 'Unknown error'}");
          return false;
        }
      } else if (response.statusCode == 302) {
        // Jika status code adalah 302, ambil URL redirect dari header
        final redirectUrl = response.headers['location'];
        print("Redirected to: $redirectUrl");

        // Di sini Anda bisa melakukan request ke URL redirect jika diperlukan
        // Misalnya, Anda bisa melakukan login ke URL baru:
        final redirectResponse = await http.get(Uri.parse(redirectUrl!));

        if (redirectResponse.statusCode == 200) {
          print("Redirect berhasil. Response: ${redirectResponse.body}");
          return true;
        } else {
          print("Redirect gagal. Status Code: ${redirectResponse.statusCode}");
          return false;
        }
      } else {
        print("Login gagal: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print("Token berhasil dihapus. Logout berhasil.");
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }
}
