import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/orders/order_card.dart';
import 'package:upstyleapp/screen/orders/order_tab_item.dart';
import 'package:upstyleapp/services/order_service.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  List<QueryDocumentSnapshot> _listOrder = [];

  bool _isLoading = true;

  final OrderService _orderService = OrderService();

  @override
  void initState() {
    fetchAllData();
    super.initState();
  }

  void fetchAllData() async {
    final userData = ref.read(userProfileProvider);
    if (userData.role == 'designer') {
      _listOrder = await _orderService
          .getAllDesOrder(FirebaseAuth.instance.currentUser!.uid);
    } else {
      _listOrder = await _orderService
          .getAllCustOrder(FirebaseAuth.instance.currentUser!.uid);
    }
    _listOrder.sort((b, a) => (a['date']).compareTo(b['date']));
    setState(() {
      _isLoading = false;
    });
  }

  void filterOrders(OrderStatus status) async {
    final userData = ref.read(userProfileProvider);
    setState(() {
      _isLoading = true;
    });
    if (userData.role == 'designer') {
      _listOrder = await _orderService.getFilteredDesOrder(
          FirebaseAuth.instance.currentUser!.uid, status.name);
    } else {
      _listOrder = await _orderService.getFilteredCustOrder(
          FirebaseAuth.instance.currentUser!.uid, status.name);
    }

    _listOrder.sort((b, a) => (a['date']).compareTo(b['date']));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'Orders',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 40,
                    margin:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      labelColor: Theme.of(context).colorScheme.surface,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.tertiary,
                      onTap: (value) {
                        // filterOrders(value);
                        switch (value) {
                          case 0:
                            return fetchAllData();
                          case 1:
                            return filterOrders(OrderStatus.waiting);
                          case 2:
                            return filterOrders(OrderStatus.onProgress);
                          case 3:
                            return filterOrders(OrderStatus.delivered);
                          case 4:
                            return filterOrders(OrderStatus.completed);
                          case 5:
                            return filterOrders(OrderStatus.canceled);
                          default:
                            return fetchAllData();
                        }
                      },
                      tabs: const [
                        OrderTabItem(
                          title: 'All',
                        ),
                        OrderTabItem(
                          title: 'Waiting',
                        ),
                        OrderTabItem(
                          title: 'On Progress',
                        ),
                        OrderTabItem(
                          title: 'Delivered',
                        ),
                        OrderTabItem(
                          title: 'Completed',
                        ),
                        OrderTabItem(
                          title: 'Canceled',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: _listOrder
                              .map(
                                (order) => OrderCard(
                                  order: OrderModel(
                                    orderId: order.id,
                                    designerId: order['designerId'],
                                    customerId: order['custId'],
                                    imageUrl: order['image_url'],
                                    price: order['price'],
                                    title: order['title'],
                                    orderDetail: order['orderDetail'],
                                    status:
                                        getStatusFromString(order['status']),
                                    date: DateTime.parse(order['date']),
                                    paymentToken: order['payment_url'],
                                    paymentUrl: order['payment_token'],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
