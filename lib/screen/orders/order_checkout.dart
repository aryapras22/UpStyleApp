import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/orders/order_payment.dart';
import 'package:upstyleapp/screen/snap/snap_web_view_screen.dart';
import 'package:upstyleapp/services/order_service.dart';
import 'package:http/http.dart' as http;

class OrderCheckout extends ConsumerStatefulWidget {
  const OrderCheckout({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<OrderCheckout> createState() => _OrderCheckoutState();
}

class _OrderCheckoutState extends ConsumerState<OrderCheckout> {
  bool _isLoading = true;
  final OrderService _orderService = OrderService();
  int tax = 0;
  bool _checkoutLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Order Details',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text('no data'),
              );
            }
            OrderModel _order = OrderModel(
              orderId: snapshot.data!.id,
              designerId: snapshot.data!['designerId'],
              customerId: snapshot.data!['custId'],
              imageUrl: snapshot.data!['image_url'],
              price: snapshot.data!['price'],
              title: snapshot.data!['title'],
              orderDetail: snapshot.data!['orderDetail'],
              status: getStatusFromString(snapshot.data!['status']),
              date: DateTime.parse(snapshot.data!['date']),
              paymentUrl: snapshot.data!['payment_url'],
              paymentToken: snapshot.data!['payment_token'],
            );
            tax = (int.parse(_order.price) * 1 ~/ 100);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesananmu',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _order
                                .imageUrl, // Replace with the URL of the dress image
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_order.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 20)),
                            Text(
                              'Rp.${_order.price.toString()}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Rincian Pembayaran',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Biaya Designer',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                            const Spacer(),
                            Text(
                              'Rp. ${_order.price}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                              'Biaya Layanan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                            const Spacer(),
                            Text(
                              'Rp. ${tax.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                            const Spacer(),
                            Text(
                              'Rp. ${(int.parse(_order.price) + tax).toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _order.status != OrderStatus.waiting
                      ? const SizedBox()
                      : ElevatedButton(
                          onPressed: () async {
                            if (!_checkoutLoading) {
                              setState(() {
                                _checkoutLoading = true;
                              });
                              final user = ref.watch(userProfileProvider);
                              var url =
                                  'https://us-central1-upstyleapp-c0154.cloudfunctions.net/midtransPaymentRequest';
                              var body = {
                                'orderId': _order.orderId,
                                'amount':
                                    (int.parse(_order.price) + tax).toString(),
                                'name': user.name,
                                'phone': user.phone ?? "",
                                'email': user.email,
                              };
                              if (_order.paymentUrl.trim() != "" &&
                                  _order.paymentToken.trim() != "") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SnapWebViewScreen(
                                      url: _order.paymentUrl,
                                    ),
                                  ),
                                );
                              } else {
                                var response =
                                    await http.post(Uri.parse(url), body: body);
                                var transaction = jsonDecode(response.body);
                                print(transaction);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SnapWebViewScreen(
                                      url: transaction['redirectUrl'],
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _checkoutLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 238, 99, 56),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _checkoutLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ))
                              : const Text(
                                  "Checkout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
