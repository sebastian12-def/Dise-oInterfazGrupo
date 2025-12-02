import 'package:flutter/material.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // CREDIT CARD
          _PaymentOption(
            icon: Icons.credit_card,
            title: "Credit Card Or Debit",
            selected: true,            // Este aparece seleccionado
            onTap: () {},
          ),

          // PAYPAL
          _PaymentOption(
            icon: Icons.account_balance_wallet,
            title: "Paypal",
            selected: false,
            onTap: () {},
          ),

          // BANK TRANSFER
          _PaymentOption(
            icon: Icons.account_balance,
            title: "Bank Transfer",
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        color: selected ? const Color(0xFFEAF0FF) : Colors.white,
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
