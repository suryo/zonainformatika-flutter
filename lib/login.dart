import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import halaman dashboard
import 'account_page.dart';
import '../services/auth_service.dart'; // Import AuthService
import 'custom_drawer.dart'; // Import CustomDrawer

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(text: 'superadmin@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '12345678');
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage; // Untuk menyimpan pesan error

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login - ZonaInformatika',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
        ),
        drawer: CustomDrawer(),
        backgroundColor: Color(0xFF151515),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to continue to ZonaInformatika',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_errorMessage != null) // Tampilkan pesan error jika ada
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to register page
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset pesan error
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
print(email);
print(password);

    try {
      final success = await _authService.login(email, password);
print(success);
      if (success) {
        // Navigasi ke dashboard jika login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountPage()),
        );
      } else {
        // Tampilkan pesan error jika login gagal
        setState(() {
          _errorMessage = 'Invalid email or password.';
        });
      }
    } catch (e) {
      // Tangani error lainnya
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
