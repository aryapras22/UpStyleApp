import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/user_model.dart';

// StateNotifier untuk mengelola UserProfile
class UserProfileNotifier extends StateNotifier<UserModel> {
  UserProfileNotifier()
      : super(UserModel(
          name: '',
          email: '',
          role: '',
          phone: '',
          address: '',
          imageUrl: '',
        ));

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void updateImageUrl(String imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void setUser({
    required String name,
    required String email,
    required String role,
    String? phone,
    String? address,
    String? imageUrl,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      role: role,
      phone: phone,
      address: address,
      imageUrl: imageUrl,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserModel>((ref) {
  return UserProfileNotifier();
});
