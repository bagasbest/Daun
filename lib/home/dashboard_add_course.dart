import 'dart:io';
import 'package:daun/database/database_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  var _title = TextEditingController();
  var _description = TextEditingController();
  int totalPhoto = 0;
  String selectedFile = "Belum ada video diunggah";

  final _formKey = GlobalKey<FormState>();

  bool visible = false;
  bool isImageAdd = false;
  XFile? _image, _video;

  List<XFile> photo = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TAMBAHKAN MATERI BARU',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/image/back.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Judul Materi",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _title,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Masukkan Judul Materi",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Judul Materi tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Deskripsi Materi",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Masukkan Deskripsi Materi",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Deskripsi Materi tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    (!isImageAdd)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashPattern: [6, 6],
                              child: Container(
                                child: Center(
                                  child: Text("* Foto Materi"),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(
                                _image!.path,
                              ),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              visible = true;
                            });
                            _image = (await DatabaseService.getImageGallery())!;
                            if (_image == null) {
                              setState(() {
                                print("Gagal ambil foto");
                                visible = false;
                              });
                            } else {
                              setState(() {
                                isImageAdd = true;
                                totalPhoto++;
                                photo.add(_image!);
                                toast('Berhasil menambah foto');
                                visible = false;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Tambah Foto Materi')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.only(left: 40,),
                          child: Text('Total Foto Materi: $totalPhoto'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        visible = true;
                      });
                      _video = (await DatabaseService.getVideoFromGallery())!;
                      if (_video == null) {
                        setState(() {
                          visible = false;
                          toast('Gagal mengupload video materi');
                        });
                      } else {
                        setState(() {
                          visible = false;
                          selectedFile = "Berhasil mengunggah video";
                          toast('Berhasil mengupload video materi');
                        });
                      }
                    },
                    child: Text(
                      "Unggah Video Materi",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Colors.green,
                  ),
                ),
                color: Colors.white,
              ),
              Text(
                selectedFile,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Visibility(
                visible: visible,
                child: SpinKitRipple(
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _image != null) {
                        setState(() {
                          visible = true;
                        });

                        var courseId = DateTime.now().millisecondsSinceEpoch;


                        if(photo.length > 0) {
                          for(int i=0; i<photo.length; i++) {
                            String? plainPhoto = await DatabaseService.uploadImageCourse(photo[i]);
                            DatabaseService.setCourseImage(courseId, plainPhoto);
                          }
                        }


                        String? urlVideo = (_video != null)
                            ? await DatabaseService.uploadVideoCourse(_video!)
                            : null;
                        if(urlVideo != null) {
                          DatabaseService.setCourseVideo(courseId, urlVideo);
                        }


                        await DatabaseService.setCourse(
                          courseId,
                          _title.text,
                          _description.text,
                        );

                        _title.clear();
                        _description.clear();
                        setState(() {
                          visible = false;
                          totalPhoto = 0;
                          _image = null;
                          photo.clear();
                          _video = null;
                          isImageAdd = false;
                          showAlertDialog(context);
                        });
                      } else if (_image == null) {
                        toast('Pastikan anda mengunggah gambar produk');
                      }
                    },
                    child: Text(
                      "Unggah Materi",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Colors.green,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
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
                  'Sukses Diunggah',
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
                'Anda berhasil mengunggah materi baru!',
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
                  Navigator.of(context).pop();
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

  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
