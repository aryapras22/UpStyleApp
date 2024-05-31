// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:upstyleapp/widgets/image_picker.dart';
import 'package:upstyleapp/widgets/input_edit_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _address = '';
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _updateProfile(
      BuildContext context, AuthServices authServices, String uid) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    try {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child("$uid.jpg");
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await authServices.updateProfile(
        uid: uid,
        name: _name,
        phone: _phone,
        address: _address,
        imageUrl: imageUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content: const Text('Update Success!'),
            showCloseIcon: true,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content: const Text('Update Failed!'),
            showCloseIcon: true,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authServices = ref.read(authServicesProvider.notifier);
    final user = ref.watch(authServicesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImagePicker(
                onSelectImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 40),
              InputEditProfile(
                initialValue: user!.name,
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty!';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _name = newValue!;
                },
              ),
              const SizedBox(height: 20),
              InputEditProfile(
                prefixIcon: Icons.email,
                initialValue: user.email,
                isReadOnly: true,
              ),
              const SizedBox(height: 20),
              InputEditProfile(
                initialValue: user.phone ?? '',
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number cannot be empty!';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _phone = newValue!;
                },
              ),
              const SizedBox(height: 20),
              InputEditProfile(
                initialValue: user.address ?? '',
                prefixIcon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address cannot be empty!';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _address = newValue!;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize:
                            Size(double.infinity, 48), // Menambahkan ini
                      ),
                      onPressed: () {
                        _updateProfile(context, authServices,
                            FirebaseAuth.instance.currentUser!.uid);
                      },
                      child: const Text('Save',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'ProductSansMedium',
                              color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
