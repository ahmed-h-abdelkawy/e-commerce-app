class UserData {
  final String id;
  final String username;
  final String email;
  final String createdAt;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
