import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daun/home/dashboard_list.dart';
import 'package:daun/onboarding/onboarding_home.dart';
import 'package:daun/onboarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'dashboard_add_course.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  var displayName;
  var avatar;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => AddCourse());
          Navigator.push(context, route);
        },
      ),
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
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
                  'Hai, ${user.displayName!}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ClipOval(
                  child: Image.network(
                    user.photoURL!,
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
            margin: EdgeInsets.only(
              top: 220,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                home.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('course')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return (snapshot.data!.size > 0)
                            ? ListOfCourse(
                                document: snapshot.data!.docs,
                                controller: scrollController,
                              )
                            : _emptyData();
                      } else {
                        return _emptyData();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Materi\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget signOut() {
    return Center(
      child: Column(
        children: [
          Text('Terdapat Kesalahan, silahkan periksa koneksi internet anda!'),
          Container(
            child: RaisedButton(
              child: Text(
                'KEMBALI',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                    (Route<dynamic> route) => false);
              },
              color: Colors.green,
            ),
          )
        ],
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
