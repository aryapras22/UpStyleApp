class UserModel {
  final String name;
  final String email;
  final String role;
  String? phone;
  String? address;
  String? imageUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.imageUrl,
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
}
