import 'package:daun/onboarding/onboarding_home.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hai Nama akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/image/google.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(
                top: 70,
              ),
              child: PageView.builder(
                  itemCount: home.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        child: Image.asset(
                          home[i].image,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 220,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  home.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
    );
  }
}
