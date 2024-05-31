import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upstyleapp/services/auth_services.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authServicesProvider);
    final imageUrl = user['imageUrl'];

    var content = imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          )
        : Image.asset(
            "assets/images/profil.png",
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          );

    if (_selectedImage != null) {
      content = Image.file(
        _selectedImage!,
        height: 130,
        width: 130,
        fit: BoxFit.cover,
      );
    }

    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/photo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
