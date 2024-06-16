import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/services/order_service.dart';

final _currentUser = FirebaseAuth.instance.currentUser!;

class OrderForm extends StatefulWidget {
  final String custId;
  final types.Room room;

  const OrderForm({super.key, required this.custId, required this.room});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPesanan = TextEditingController();
  final TextEditingController _harga = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();

  final OrderService _orderService = OrderService();

  void _saveOrder() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_image == null) {
      return;
    }
    final order = OrderModel(
      designerId: _currentUser.uid,
      customerId: widget.custId,
      imageUrl: _image!.path,
      price: _harga.text,
      title: _namaPesanan.text,
      orderDetail: _deskripsi.text,
      status: OrderStatus.waiting,
      date: DateTime.now(),
    );
    await _orderService.createOrder(order, widget.room);
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Buat Pesanan",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _namaPesanan,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.edit_square,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  hintText: 'Nama Pesanan',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _harga,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  prefixText: 'Rp. ',
                  prefixStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Harga',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _deskripsi,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.edit_document,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  hintText: 'Deskripsi Pesanan',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final pickedImage = await _picker.pickImage(
                      source: ImageSource.camera, imageQuality: 80);
                  setState(() {
                    if (pickedImage != null) {
                      _image = File(pickedImage.path);
                    } else {
                      const SnackBar(
                        content: Text('No image selected.'),
                      );
                    }
                  });
                },
                child: _image == null
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        color: Theme.of(context).colorScheme.primary,
                        dashPattern: const [6, 3],
                        strokeWidth: 2,
                        radius: const Radius.circular(10),
                        child: SizedBox(
                          width: 500,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/upload_active.png',
                                ),
                                Text(
                                  "Upload your image here",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: SizedBox(
                          width: 500,
                          height: 300,
                          child: Center(
                            child: Ink.image(
                              image: Image.file(
                                File(_image!.path),
                              ).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _saveOrder();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 99, 56),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Buat Pesanan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
