import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/chat/chat_page.dart';
import 'package:upstyleapp/screen/orders/order_checkout.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/order_service.dart';

class OrderCard extends ConsumerStatefulWidget {
  final OrderModel order;

  OrderCard({required this.order, super.key});

  @override
  ConsumerState<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<OrderCard> {
  final _orderService = OrderService();

  void _showChangeStatusAlert(context, label, OrderStatus status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black),
        ),
        content: Text(
          'You cannot undo this decision',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
              padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          Ink(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.background),
                padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
              ),
              onPressed: () async {
                await _orderService.changeStatus(widget.order.orderId, status);
                widget.order.status = status;
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProfileProvider);
    bool _designer = false;
    if (_userData.role == 'designer') {
      _designer = true;
    }
    final _roomId = ChatService().getRoomId(widget.order.designerId, widget.order.customerId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderCheckout(
              orderId: widget.order.orderId,
            ),
          ),
        );
      },
      child: Container(
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
                  widget.order.formattedDate,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: widget.order.statusColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.order.textStatus,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: widget.order.statusColor),
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
                      child: Image.network(
                        widget.order.imageUrl,
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
                              widget.order.title,
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
                              widget.order.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            'Rp. ${widget.order.price}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                      widget.order.status == OrderStatus.completed
                          ? _designer
                              ? const SizedBox()
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
                                  onPressed: () {
                                    //kasih review
                                  },
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
                                              color: Colors.white,
                                              fontSize: 12)),
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
                              onPressed: () {
                                if (_designer &&
                                    widget.order.status ==
                                        OrderStatus.onProgress) {
                                  // ubah status jadi delivered
                                  _showChangeStatusAlert(
                                      context,
                                      'Deliver this order?',
                                      OrderStatus.delivered);
                                }
                                if (_designer &&
                                    widget.order.status !=
                                        OrderStatus.onProgress) {
                                  // chat customer
                                } else if (!_designer &&
                                    widget.order.status ==
                                        OrderStatus.delivered) {
                                  //ubah status jadi selesai
                                  _showChangeStatusAlert(
                                      context,
                                      'Finish this order?',
                                      OrderStatus.completed);
                                } else if (!_designer &&
                                    widget.order.status !=
                                        OrderStatus.delivered) {
                                  //chat designer
                                }
                              },
                              icon: _designer
                                  ? widget.order.status !=
                                          OrderStatus.onProgress
                                      ? const Icon(
                                          Icons.message_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                  : widget.order.status == OrderStatus.delivered
                                      ? const Icon(
                                          Icons.done_all_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.message_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                              label: _designer
                                  ? widget.order.status !=
                                          OrderStatus.onProgress
                                      ? Text(
                                          'Chat Customer',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        )
                                      : Text(
                                          'Kirim',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        )
                                  : widget.order.status == OrderStatus.delivered
                                      ? Text(
                                          'Selesai',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        )
                                      : Text(
                                          'Chat Designer',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
