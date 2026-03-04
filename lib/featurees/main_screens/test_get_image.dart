import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImgbbUploadScreen extends StatefulWidget {
  @override
  _ImgbbUploadScreenState createState() => _ImgbbUploadScreenState();
}

class _ImgbbUploadScreenState extends State<ImgbbUploadScreen> {
  File? _image;
  bool _isLoading = false;

  // استبدلي هذا بالمفتاح الذي حصلتِ عليه من الموقع
  final String apiKey = "7b2be8682e2f557719ba5e1c0666352a";

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
      });

      try {
        // تجهيز الطلب لإرساله لـ ImgBB
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
        );
        request.files.add(
          await http.MultipartFile.fromPath('image', _image!.path),
        );

        var response = await request.send();
        if (response.statusCode == 200) {
          var resData = await http.Response.fromStream(response);
          var jsonRes = jsonDecode(resData.body);

          // هذا هو الرابط المباشر للصورة
          String imageUrl = jsonRes['data']['url'];

          // الآن نحفظ الرابط في Firestore (داخل الـ Document الخاص بكِ)
          await FirebaseFirestore.instance.collection('my_images').add({
            'url': imageUrl,
            'time': Timestamp.now(),
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('تم الرفع والحفظ بنجاح!')));
        }
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الرفع بدون فيزا")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Icon(Icons.image, size: 100),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text("اختيار صورة ورفعها"),
                  ),
          ],
        ),
      ),
    );
  }
}

class DisplayImagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("معرض الصور المرفوعة"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('my_images')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. فحص حالة الخطأ (مهم جداً لتجنب الانهيار)
          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ ما: ${snapshot.error}"));
          }

          // 2. حالة التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 3. فحص وجود البيانات وصحتها قبل الاستخدام
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(child: Text("لا توجد صور مرفوعة بعد"));
          }

          // 4. عرض الصور بعد التأكد من وجود البيانات
          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var document = docs[index].data() as Map<String, dynamic>;

              // التأكد من وجود الحقل 'url' داخل المستند لتجنب خطأ آخر
              String? imageUrl = document.containsKey('url')
                  ? document['url']
                  : null;

              if (imageUrl == null) {
                return Icon(Icons.image_not_supported, color: Colors.grey);
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
