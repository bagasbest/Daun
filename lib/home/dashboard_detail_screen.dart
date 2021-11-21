import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daun/home/dashboard_detail_edit.dart';
import 'package:daun/utils/flutter_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'home_screen.dart';

class DashboardDetailScreen extends StatefulWidget {
  final String courseId;
  final String title;
  final String description;

  DashboardDetailScreen({
    required this.courseId,
    required this.title,
    required this.description,
  });

  @override
  _DashboardDetailScreenState createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {
  List<String> imageContents = [];
  int currentIndex = 0;
  String videoUrl = "";
  bool isLoading = true;

  var _controller;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    fetchVideo();
  }

  fetchVideo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('course')
        .doc(widget.courseId)
        .collection('video')
        .get();

    if (snapshot.docs.length > 0) {
      videoUrl = snapshot.docs[0]['video'].toString();
      _controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }

    fetchImage();
  }

  fetchImage() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('course')
        .doc(widget.courseId)
        .collection('image')
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      String image = snapshot.docs[i]['image'].toString();
      imageContents.add(image);
      if (i == snapshot.docs.length - 1) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'DETAIL MATERI',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('assets/image/back.png'),
              ),
              actions: [
                (user.email == "rekkyar@gmail.com")
                    ? GestureDetector(
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (context) => DashboardEdit(
                              courseId: widget.courseId,
                              title: widget.title,
                              description: widget.description,
                            ),
                          );
                          Navigator.push(context, route);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 16,
                ),
                (user.email == "rekkyar@gmail.com")
                    ? GestureDetector(
                        onTap: () {
                          _showDialogConfirmation();
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 16,
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  (videoUrl != "")
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (videoUrl != "") ? fab() : Container(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            itemCount: imageContents.length,
                            onPageChanged: (int index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            itemBuilder: (_, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageContents[i],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imageContents.length,
                              (index) => buildDot(index, context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Judul Materi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          'Penjelasan:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget fab() {
    return Center(
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
          borderRadius: BorderRadius.circular(20), color: Colors.grey),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Colors.green,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Sukses Menghapus',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Anda berhasil menghapus materi!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FlatButton(
                onPressed: () {
                  Route route = MaterialPageRoute(
                    builder: (context) => HomePage(),
                  );
                  Navigator.push(context, route);
                },
                child: Container(
                  width: 250,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          elevation: 10,
        );
      },
    );
  }

  _showDialogConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Color(0xffDD5151),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'KONFIRMASI HAPUS MATERI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Apakah anda yakin ingin menghapus materi ini ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('course')
                    .doc(widget.courseId)
                    .delete()
                    .then((_) async {
                  if (videoUrl != "") {
                    await FirebaseStorage.instance
                        .refFromURL(videoUrl)
                        .delete();
                  }

                  for (int i = 0; i < imageContents.length; i++) {
                    await FirebaseStorage.instance
                        .refFromURL(imageContents[i])
                        .delete();
                  }

                  showAlertDialog(context);
                }).catchError((_) {
                  toast("Gagal menghapus materi");
                });
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }
}
