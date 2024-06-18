class UserModel {
  final String name;
  final String email;
  final String role;
  String? phone;
  String? address;
  String? imageUrl;
  List? favorites;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.imageUrl,
    this.favorites,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
        'phone': phone,
        'address': address,
        'imageUrl': imageUrl,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? imageUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
