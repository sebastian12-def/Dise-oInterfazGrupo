import 'package:flutter/material.dart';

class CartTotalWidget extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double tax;

  const CartTotalWidget({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Subtotal", subtotal),
          _row("Shipping", shipping),
          _row("Tax", tax),
          const Divider(height: 28),
          _row("Total", total, bold: true),
        ],
      ),
    );
  }

  Widget _row(String title, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? Colors.blue : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
