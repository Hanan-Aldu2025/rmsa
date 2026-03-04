// lib/featurees/main_screens/profile/data/datasources/profile_remote_data_source.dart

import 'dart:convert';

import 'package:appp/featurees/main_screens/profile/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

/// مصدر البيانات البعيد - مسؤول عن التواصل مع Firebase و ImgBB
class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final String apiKey = "7b2be8682e2f557719ba5e1c0666352a";

  ProfileRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// الاستماع لتغييرات بيانات المستخدم
  Stream<UserModel> getUserData(String uid) {
    return firestore
        .collection('user_information')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDoc(snapshot, uid));
  }

  /// رفع صورة إلى ImgBB والحصول على الرابط
  Future<String> uploadImageToImgBB(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        var resData = await http.Response.fromStream(response);
        var jsonRes = jsonDecode(resData.body);
        return jsonRes['data']['url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// تحديث صورة المستخدم في Firestore
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    await firestore.collection('user_information').doc(uid).update({
      'profile_image': imageUrl,
    });
  }
}
