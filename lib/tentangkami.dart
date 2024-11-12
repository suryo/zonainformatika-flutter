import 'package:flutter/material.dart';

class Tentangkami extends StatelessWidget {
  final String data;

  // Menerima data melalui constructor
  Tentangkami({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Kami'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data yang diterima:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              data, // Menampilkan data yang diterima
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
