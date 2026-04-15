class UserData {
  final String id;
  final String email;
  final DateTime createdAt;
  final List<String> favoriteCategories;
  final String fcmToken;
  final bool isOnboardingDone;

  UserData({
    required this.id,
    required this.email,
    required this.createdAt,
    this.favoriteCategories = const [],
    this.fcmToken = '',
    this.isOnboardingDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt,
      'favoriteCategories': favoriteCategories,
      'fcmToken': fcmToken,
      'isOnboardingDone': isOnboardingDone,
    };
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is DateTime) return value;
    if (value != null && value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate() as DateTime;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      createdAt: _parseCreatedAt(map['createdAt']),
      favoriteCategories: List<String>.from(map['favoriteCategories'] ?? []),
      fcmToken: map['fcmToken'] ?? '',
      isOnboardingDone: map['isOnboardingDone'] ?? false,
    );
  }
}
