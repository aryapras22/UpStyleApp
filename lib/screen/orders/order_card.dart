import 'package:flutter/material.dart';
import 'package:upstyleapp/model/order.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                order.formattedDate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: order.statusColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  order.textStatus,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: order.statusColor),
                ),
              )
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: Image.asset(
                      order.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.475,
                          child: Text(
                            order.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.475,
                          child: Text(
                            order.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          order.price,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    order.status == OrderStatus.completed
                        ? ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 16),
                              ),
                              shape: WidgetStatePropertyAll<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text('Beri Review',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Colors.white, fontSize: 12)),
                          )
                        : ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 16),
                              ),
                              shape: WidgetStatePropertyAll<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.message_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text('Chat Designer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Colors.white, fontSize: 12)),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
