
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:news_app/core/services/local_database_hive.dart';


// class ProfileService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final LocalDatabaseHive _hive = LocalDatabaseHive();

//   // مفاتيح Hive
//   static const String _hivePhotoBytes = 'profile_photo_bytes';
//   static const String _hivePhotoUrl   = 'profile_photo_url';

//   // ─── رفع صورة جديدة ──────────────────────────────────────────────
//   Future<String?> uploadProfilePhoto(File imageFile) async {
//     final user = _auth.currentUser;
//     if (user == null) return null;

//     final bytes = await imageFile.readAsBytes();

//     // 1. رفع الصورة إلى Firebase Storage
//     final storageRef = _storage
//         .ref()
//         .child('profile_photos')
//         .child('${user.uid}.jpg');

//     await storageRef.putData(
//       bytes,
//       SettableMetadata(contentType: 'image/jpeg'),
//     );

//     // 2. جلب الرابط
//     final downloadUrl = await storageRef.getDownloadURL();

//     // 3. حفظ الرابط في Firestore
//     await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .set({'photoUrl': downloadUrl}, SetOptions(merge: true));

//     // 4. حفظ الـ bytes في Hive — للاستخدام الفوري بدون إنترنت
//     await _hive.saveData<Uint8List>(_hivePhotoBytes, bytes);
//     await _hive.saveData<String>(_hivePhotoUrl, downloadUrl);

//     return downloadUrl;
//   }

//   // ─── جلب الصورة: Hive أولاً ثم Firebase ──────────────────────────
//   /// يُرجع:
//   ///   - [Uint8List]  إذا وُجدت الصورة في Hive  (عرض فوري)
//   ///   - [String]     رابط URL من Firebase        (عرض عبر الشبكة)
//   ///   - null         إذا لم تكن هناك صورة أصلاً
//   Future<Object?> getProfilePhoto() async {
//     final user = _auth.currentUser;
//     if (user == null) return null;

//     // 1. ابحث في Hive أولاً — فوري بدون إنترنت
//     final cachedBytes = await _hive.getData<Uint8List>(_hivePhotoBytes);
//     if (cachedBytes != null) return cachedBytes;

//     // 2. إذا لم يجد في Hive، اجلب الرابط من Firestore
//     final doc = await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     final url = doc.data()?['photoUrl'] as String?;
//     if (url == null) return null;

//     // 3. حمّل الـ bytes من Storage وخزّنها في Hive للمرات القادمة
//     try {
//       final downloadRef = _storage.refFromURL(url);
//       final bytes = await downloadRef.getData();
//       if (bytes != null) {
//         await _hive.saveData<Uint8List>(_hivePhotoBytes, bytes);
//         await _hive.saveData<String>(_hivePhotoUrl, url);
//         return bytes;
//       }
//     } catch (_) {
//       // فشل التحميل — أرجع الرابط مباشرة كاحتياط
//       return url;
//     }

//     return url;
//   }

//   // ─── حذف صورة البروفايل ──────────────────────────────────────────
//   Future<void> deleteProfilePhoto() async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     try {
//       await _storage
//           .ref()
//           .child('profile_photos')
//           .child('${user.uid}.jpg')
//           .delete();
//     } catch (_) {}

//     await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .update({'photoUrl': FieldValue.delete()});

//     await _hive.deleteData(_hivePhotoBytes);
//     await _hive.deleteData(_hivePhotoUrl);
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/services/local_database_hive.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalDatabaseHive _hive = LocalDatabaseHive();

  static const String _hivePhotoBytes = 'profile_photo_bytes';

  // ─── رفع صورة جديدة (Base64 في Firestore بدلاً من Storage) ─────
  Future<void> uploadProfilePhoto(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // حفظ في Firestore مباشرة — بدون Firebase Storage
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({'photoBase64': base64Image}, SetOptions(merge: true));

    // حفظ الـ bytes في Hive للعرض الفوري بدون إنترنت
    await _hive.saveData<Uint8List>(_hivePhotoBytes, bytes);
  }

  // ─── جلب الصورة: Hive أولاً ثم Firestore ─────────────────────
  Future<Uint8List?> getProfilePhoto() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final cachedBytes = await _hive.getData<Uint8List>(_hivePhotoBytes);
    if (cachedBytes != null) return cachedBytes;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final base64Image = doc.data()?['photoBase64'] as String?;
    if (base64Image == null) return null;

    final bytes = base64Decode(base64Image);
    await _hive.saveData<Uint8List>(_hivePhotoBytes, bytes);
    return bytes;
  }

  // ─── حذف صورة البروفايل ────────────────────────────────────
  Future<void> deleteProfilePhoto() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({'photoBase64': FieldValue.delete()});

    await _hive.deleteData(_hivePhotoBytes);
  }
}