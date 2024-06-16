import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:upstyleapp/screen/orders/order_tab_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
=======
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/screen/orders/order_card.dart';
import 'package:upstyleapp/screen/orders/order_tab_item.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> listOrder = [
    Order(
      designerId: 'designer001',
      customerId: 'customer001',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 300.000',
      title: 'Basic Logo Design',
      orderDetail: 'Simple logo design for startup.',
      status: OrderStatus.waiting,
      date: DateTime.now(),
    ),
    Order(
      designerId: 'designer002',
      customerId: 'customer002',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 125.000',
      title: 'Business Card Design',
      orderDetail: 'Professional business card design.',
      status: OrderStatus.inProgress,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Order(
      designerId: 'designer003',
      customerId: 'customer003',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 275.000',
      title: 'Website Banner Design',
      orderDetail: 'Banner design for website homepage.',
      status: OrderStatus.completed,
      date: DateTime.now().subtract(Duration(days: 7)),
    ),
    Order(
      designerId: 'designer004',
      customerId: 'customer004',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 425.000',
      title: 'Full Branding Package',
      orderDetail: 'Complete branding package for new company.',
      status: OrderStatus.canceled,
      date: DateTime.now().subtract(Duration(days: 10)),
    ),
  ];

  List<Order> filteredOrders = [];

  @override
  void initState() {
    filteredOrders = listOrder;
    super.initState();
  }

  void filterOrders(int statusIndex) {
    setState(() {
      if (statusIndex == 0) {
        filteredOrders = listOrder;
      } else {
        filteredOrders = listOrder
            .where((order) => order.status.index == statusIndex - 1)
            .toList();
      }
    });
  }
>>>>>>> f1a81b4f97a7f3ee68f73c630444cdbcc6b58b9f

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          SizedBox(
<<<<<<< HEAD
            height: 150,
            child: AppBar(
=======
            height: 200,
            child: AppBar(
              scrolledUnderElevation: 0,
>>>>>>> f1a81b4f97a7f3ee68f73c630444cdbcc6b58b9f
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
<<<<<<< HEAD
                    margin: const EdgeInsets.symmetric(horizontal: 20),
=======
                    margin:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
>>>>>>> f1a81b4f97a7f3ee68f73c630444cdbcc6b58b9f
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
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
<<<<<<< HEAD
=======
                      onTap: (value) {
                        filterOrders(value);
                      },
>>>>>>> f1a81b4f97a7f3ee68f73c630444cdbcc6b58b9f
                      tabs: const [
                        OrderTabItem(
                          title: 'All',
                        ),
                        OrderTabItem(
                          title: 'Waiting',
                        ),
                        OrderTabItem(
                          title: 'In Progress',
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
<<<<<<< HEAD
          Container(),
=======
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: filteredOrders
                        .map(
                          (order) => OrderCard(
                            order: order,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
>>>>>>> f1a81b4f97a7f3ee68f73c630444cdbcc6b58b9f
        ],
      ),
    );
  }
}
