import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daun/home/dashboard_detail_screen.dart';
import 'package:flutter/material.dart';

class ListOfCourse extends StatelessWidget {
  final List<DocumentSnapshot> document;
  final ScrollController controller;


  ListOfCourse({required this.document, required this.controller});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      controller: controller,
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String courseId = document[i]['uid'].toString();
        String title = document[i]['title'].toString();
        String description = document[i]['description'].toString();

        return GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => DashboardDetailScreen(
                courseId: courseId,
                title: title,
                description: description,
              ),
            );
            Navigator.push(context, route);
          },
          child: Container(
            height: 120,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue]
              ),
            ),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 16,
                    top: 7,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        description,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
