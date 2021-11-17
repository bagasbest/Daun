import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daun/home/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  static Future<XFile?> getImageGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if ((image != null)) {
      return image;
    } else {
      return null;
    }
  }

  static getVideoFromGallery() async {
    var video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if ((video != null)) {
      return video;
    } else {
      return null;
    }
  }

  static Future<String?> uploadImageCourse(XFile imageFile) async {
    String filename = basename(imageFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('image/$filename');
    await reference.putFile(File(imageFile.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static Future<String?> uploadVideoCourse(XFile video) async {
    String filename = basename(video.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('video/$filename');
    await reference.putFile(File(video.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }





  static void deleteCourse(String courseId) {
    try {
      FirebaseFirestore.instance
          .collection('course')
          .doc(courseId)
          .delete()
          .then(
            (value) => {toast('success')},
          );
    } catch (error) {
      toast(
          'Gagal menambahkan produk baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static Future<void> setCourseImage(int courseId, String? plainPhoto) async {
    try {
      var doc = DateTime.now().millisecondsSinceEpoch;

      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseId.toString())
          .collection("image")
          .doc(doc.toString())
          .set({
        'uid': doc.toString(),
        'image': plainPhoto,
      });
    } catch (error) {
      toast(
          'Gagal menambahkan produk baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static void setCourseVideo(int courseId, String? urlVideo) async {
    try {
      var doc = DateTime.now().millisecondsSinceEpoch;

      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseId.toString())
          .collection("video")
          .doc(doc.toString())
          .set({
        'uid': doc.toString(),
        'video': urlVideo,
      });
    } catch (error) {
      toast(
          'Gagal menambahkan produk baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static Future<void> setCourse(int courseId, String title, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseId.toString())
          .set({
        'uid': courseId.toString(),
        'title': title,
        'description': description,
      });
    } catch (error) {
      toast(
          'Gagal menambahkan produk baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static updateCourse(String courseId, String title, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseId.toString())
          .update({
        'title': title,
        'description': description,
      });
    } catch (error) {
      toast(
          'Gagal menambahkan produk baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }
}
