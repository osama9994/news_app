// class UserData {
//   final String id;
//   // final String username;
//   final String email;
//   final DateTime createdAt;

//   UserData({
//     required this.id,
//     // required this.username,
//     required this.email,
//     required this.createdAt,
//   });

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};
  
//     result.addAll({'id': id});
//     // result.addAll({'username': username});
//     result.addAll({'email': email});
//     result.addAll({'createdAt': createdAt});
  
//     return result;
//   }

//   factory UserData.fromMap(Map<String, dynamic> map) {
//     return UserData(
//       id: map['id'] ?? '',
//       // username: map['username'] ?? '',
//       email: map['email'] ?? '',
//       createdAt: map['createdAt'] ?? '',
//     );
//   }
// }
class UserData {
  final String id;
  final String email;
  final DateTime createdAt;
  
  // ✅ جديد
  final List<String> favoriteCategories;
  final String fcmToken;
  final bool isOnboardingDone; // حتى لا نعرض شاشة الفئات مرة ثانية

  UserData({
    required this.id,
    required this.email,
    required this.createdAt,
    this.favoriteCategories = const [], // ✅ افتراضي فارغ
    this.fcmToken = '',
    this.isOnboardingDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt,
      'favoriteCategories': favoriteCategories, // ✅
      'fcmToken': fcmToken,                     // ✅
      'isOnboardingDone': isOnboardingDone,     // ✅
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now(),
      favoriteCategories: List<String>.from(map['favoriteCategories'] ?? []), // ✅
      fcmToken: map['fcmToken'] ?? '',
      isOnboardingDone: map['isOnboardingDone'] ?? false,
    );
  }
}
