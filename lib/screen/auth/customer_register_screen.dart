// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/auth/verification_screen.dart';
import 'package:upstyleapp/services/auth_services.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _isObscurePassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _isObscureConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _authServices.register(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      );

      // Hapus akun jika dalam 30 menit tidak memverifikasi email
      Timer(const Duration(minutes: 30), () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.delete();
        }
      });

      final user = FirebaseAuth.instance.currentUser;
      await _authServices.addUserToFirestore(
          email: user!.email!,
          uid: user.uid,
          name: _nameController.text,
          role: 'customer');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const VerificationScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering user: $e'),
        ),
      );

      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createUserCollection(User user) async {
    try {
      await _authServices.addUserToFirestore(
        uid: user.uid,
        email: user.email!,
        name: _nameController.text,
        role: 'customer',
      );
    } catch (e) {
      print('Error adding user to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding user to Firestore: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'ProductSansMedium',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 150, 150, 150),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Subtitle',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Subtitle',
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 238, 99, 56),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Subtitle',
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 238, 99, 56),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                obscureText: _obscureTextPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextPassword
                          ? Icons.visibility_off
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 150, 150, 150),
                    ),
                    onPressed: _isObscurePassword,
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Subtitle',
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 238, 99, 56),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: _obscureTextConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 150, 150, 150),
                    ),
                    onPressed: _isObscureConfirmPassword,
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Subtitle',
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 238, 99, 56),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 238, 99, 56),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
