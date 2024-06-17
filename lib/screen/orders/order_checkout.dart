import 'package:flutter/material.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/screen/orders/order_payment.dart';
import 'package:upstyleapp/services/order_service.dart';

class OrderCheckout extends StatefulWidget {
  const OrderCheckout({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderCheckout> createState() => _OrderCheckoutState();
}

class _OrderCheckoutState extends State<OrderCheckout> {
  bool _isLoading = true;
  final OrderService _orderService = OrderService();
  late OrderModel _order;
  int tax = 0;

  Future<void> _fetchOrderData() async {
    final orderData = await _orderService.getOrderById(widget.orderId);
    setState(() {
      _order = OrderModel(
        orderId: orderData['id'],
        designerId: orderData['designerId'],
        customerId: orderData['custId'],
        imageUrl: orderData['image_url'],
        price: orderData['price'],
        title: orderData['title'],
        orderDetail: orderData['orderDetail'],
        status: getStatusFromString(orderData['status']),
        date: DateTime.parse(orderData['date']),
      );

      tax = (int.parse(_order.price) * 1 ~/ 100);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchOrderData();
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
          'Checkout',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                   OrderPayment(order: _order)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 238, 99, 56),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Checkout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
