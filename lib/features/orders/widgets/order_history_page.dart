// order_history_page.dart
import 'package:flutter/material.dart';
import '../widgets/order_card_widget.dart';
import '../../shared/order_model.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({super.key});

  // Datos de ejemplo (luego vendrán de un provider/API)
  final List<Order> orders = [
    Order(
      id: "LONSU348JK",
      date: DateTime(2017, 8, 1),
      status: "Shipping",
      itemCount: 2,
      total: 298.43,
      items: [
        OrderItem(
          productName: "Nike Air Zoom Pegasus",
          price: 149.21,
          quantity: 2,
        ),
      ],
    ),
    Order(
      id: "SD01345KJD",
      date: DateTime(2017, 8, 1),
      status: "Shipping",
      itemCount: 1,
      total: 398.43,
      items: [
        OrderItem(
          productName: "Nike Air Max 270",
          price: 398.43,
          quantity: 1,
        ),
      ],
    ),
    // Agrega más pedidos según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Orders",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              "${orders.length} orders found",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Lista de pedidos
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderCardWidget(order: orders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}