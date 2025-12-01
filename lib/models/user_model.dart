class User {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      photoUrl: json['photo_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
