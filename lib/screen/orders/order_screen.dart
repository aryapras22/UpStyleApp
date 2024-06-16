import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/orders/order_tab_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: AppBar(
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
          Container(),
        ],
      ),
    );
  }
}
