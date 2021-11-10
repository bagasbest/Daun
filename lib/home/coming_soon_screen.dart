import 'package:flutter/material.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  _ComingSoonScreenState createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Text(
            'COMING SOON',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        // leading: GestureDetector(
        //   onTap: () => Navigator.of(context).pop(),
        //   child: Image.asset('assets/image/back.png'),
        // ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/image/logo.png',
              height: 150,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'APLIKASI INI SAYA BUAT UNTUK UNTUK TUGAS AKHIR KULIAH SAYA.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
