import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/screen/dashboard_screen.dart';
import 'package:upstyleapp/screen/orders/order_screen.dart';
import 'package:upstyleapp/services/order_service.dart';

class OrderPayment extends StatefulWidget {
  const OrderPayment({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrderPayment> createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  Future<void> _pay() async {
    setState(() {
      _isLoading = true;
    });
    await _orderService.changeStatus(widget.order.orderId, OrderStatus.waiting);
    if (!mounted) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          selectedIndex: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Payment',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 125,
                    child: Image.asset(
                      'assets/images/bca.png',
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: '6750728977'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nomor rekening disalin'),
                            ),
                          );
                        },
                        child: Text(
                          '6750728977',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: const Color.fromARGB(255, 0, 110, 200),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'A/N ADINE NUR AZALIYAH',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    'Total: Rp. ${(int.parse(widget.order.price) * 1.01).toInt()}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _isLoading ? null : _pay();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 238, 99, 56),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text(
                      "Saya sudah bayar",
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
