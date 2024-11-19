import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart'; // Pastikan Anda memiliki CustomBottomNavBar di proyek Anda

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        // title: Text('About Us'),
        title: Text(
          'ZonaInformatika',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Color(0xFF151515),
      body: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'About Us', // Judul Halaman
                style: TextStyle( color: Colors.white,fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Company Overview',
                style: TextStyle( color: Colors.white,fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Zonainformatika adalah platform belajar teknologi dan informatika secara online yang baru saja berdiri. Dikembangkan khusus untuk membantu individu memperoleh pengetahuan dan keterampilan di bidang teknologi informasi agar dapat bersaing di era digital saat ini. Dengan komitmen untuk memberikan akses pendidikan yang mudah dan berkualitas, Zonainformatika bertujuan untuk menjadi mitra pembelajaran yang terpercaya bagi mereka yang ingin mengembangkan karir mereka di dunia teknologi. Kami menyediakan berbagai kursus dan materi pembelajaran yang dirancang untuk memenuhi kebutuhan belajar beragam, mulai dari pemula hingga tingkat lanjutan. '
                    'Dalam beberapa tahun mendatang, Zonainformatika bertekad untuk berkembang menjadi salah satu platform belajar terkemuka di bidang teknologi dan informatika di Indonesia. Dengan dukungan komunitas yang kuat dan komitmen untuk terus meningkatkan kualitas layanan, kami yakin dapat menjadi mitra yang berharga bagi generasi muda Indonesia dalam meraih kesuksesan di era digital.',
                style: TextStyle( color: Colors.white,fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission',
                style: TextStyle( color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Zonainformatika berkomitmen untuk menjadi platform pembelajaran online yang andal dan inovatif di bidang teknologi dan informatika. Misi kami adalah menyediakan akses pendidikan yang mudah, terjangkau, dan berkualitas bagi setiap individu yang ingin mengembangkan keterampilan teknologi informasi. Kami berupaya membekali generasi muda Indonesia dengan pengetahuan dan keterampilan yang dibutuhkan untuk sukses di era digital. Dengan menyediakan kursus yang terstruktur dan didukung oleh komunitas belajar yang kuat, kami yakin dapat membantu pengguna kami mencapai potensi maksimal dan mewujudkan karir impian mereka di dunia teknologi',
                style: TextStyle( color: Colors.white,fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Text(
                'Contact Us',
                style: TextStyle( color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'For inquiries, please contact us at:\nsuryoatm@gmail.com\nPhone: +62812 1717 3406',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 30),
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
