import 'package:daun/login/login_screen.dart';
import 'package:daun/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';
import 'onboarding/onboarding_screen.dart';

/// main program untuk memulai aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /// cek apakah pengguna sudah login sebelumnya atau belum, jika sudah langsung masuk ke homepage, jika belum masuk ke login
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return ChangeNotifierProvider(
        create: (BuildContext context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Numans'),
          home: HomePage(),
        ),
      );
    } else {
      return ChangeNotifierProvider(
        create: (BuildContext context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Numans'),
          home: OnBoardingScreen(),
        ),
      );
    }
  }
}

