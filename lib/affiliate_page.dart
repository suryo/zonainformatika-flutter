import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart'; // Pastikan Anda memiliki CustomBottomNavBar di proyek Anda

class AffiliatePage extends StatefulWidget {
  @override
  _AffiliatePageState createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Affiliate',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView agar bisa di-scroll
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Affiliate Program',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Join our affiliate program and start earning by sharing our products with others. Below are the steps to get started.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Text(
                'How it works:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Sign up for our affiliate program.\n'
                    '2. Share your unique affiliate link with friends and family.\n'
                    '3. Earn commission for each successful referral.\n'
                    '4. Track your earnings through our affiliate dashboard.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Text(
                'Benefits of Joining:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '• Earn passive income.\n'
                    '• Work from anywhere.\n'
                    '• Access to marketing materials.\n'
                    '• Flexible payout options.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Text(
                'Become an Affiliate Today!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Tindakan untuk bergabung dengan program afiliasi, misalnya membuka link
                  // untuk mendaftar afiliasi atau menavigasi ke halaman lainnya
                },
                child: Text('Join Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar( // Menggunakan CustomBottomNavBar yang sudah ada
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
