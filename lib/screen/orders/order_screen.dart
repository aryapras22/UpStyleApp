import 'package:flutter/material.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/screen/orders/order_card.dart';
import 'package:upstyleapp/screen/orders/order_tab_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderModel> listOrder = [
    OrderModel(
      designerId: 'designer001',
      customerId: 'customer001',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 300.000',
      title: 'Basic Logo Design',
      orderDetail: 'Simple logo design for startup.',
      status: OrderStatus.waiting,
      date: DateTime.now(),
    ),
    OrderModel(
      designerId: 'designer002',
      customerId: 'customer002',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 125.000',
      title: 'Business Card Design',
      orderDetail: 'Professional business card design.',
      status: OrderStatus.inProgress,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    OrderModel(
      designerId: 'designer003',
      customerId: 'customer003',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 275.000',
      title: 'Website Banner Design',
      orderDetail: 'Banner design for website homepage.',
      status: OrderStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    OrderModel(
      designerId: 'designer004',
      customerId: 'customer004',
      imageUrl: 'assets/images/image_placeholder.png',
      price: 'Rp. 425.000',
      title: 'Full Branding Package',
      orderDetail: 'Complete branding package for new company.',
      status: OrderStatus.canceled,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  List<OrderModel> filteredOrders = [];

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                        filterOrders(value);
                      },
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
        ],
      ),
    );
  }
}
