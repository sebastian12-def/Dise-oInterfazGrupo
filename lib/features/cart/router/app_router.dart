import 'package:flutter/material.dart';

// Cart
import '../pages/cart_page.dart';

// Payment (ubicación correcta)
import '../pages/payment_method_page.dart';
import '../pages/payment_summary_page.dart';
import '../pages/order_completed_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartPage());

      case '/payment-method':
        return MaterialPageRoute(builder: (_) => const PaymentMethodPage());

      case '/payment-summary':
        return MaterialPageRoute(builder: (_) => const PaymentSummaryPage());

      case '/order-completed':
        return MaterialPageRoute(builder: (_) => const OrderCompletedPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Página no encontrada")),
          ),
        );
    }
  }
}
