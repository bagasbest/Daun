import 'package:daun/home/home_screen.dart';
import 'package:daun/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.2,
            ),
            child: Text(
              'MASUK',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset('assets/image/back.png'),
          ),
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
                height: 200,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Silahkan Masuk',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 250,
                height: 55,
                child: RaisedButton(
                  onPressed: () async {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    await provider.googleLogin();

                    Route route =
                        MaterialPageRoute(builder: (context) => HomePage());
                    Navigator.push(context, route);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/image/google.png',
                        height: 31,
                      ),
                      Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
