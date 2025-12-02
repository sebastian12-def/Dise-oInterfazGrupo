import 'package:flutter/material.dart';

class PaymentSummaryPage extends StatelessWidget {
  const PaymentSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Summary"),
      ),
      body: const Center(
        child: Text("Resumen del pago"),
      ),
    );
  }
}
