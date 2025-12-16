// app_router.dart - VERSIÓN CORRECTA Y COMPLETA
import 'package:flutter/material.dart';

// Cart
import '../features/cart/pages/cart_page.dart';

// Payment
import '../features/cart/pages/payment_method_page.dart';
import '../features/cart/pages/payment_summary_page.dart';
import '../features/cart/pages/order_completed_page.dart';

// Order History - PERSONA 5
import '../features/orders/widgets/order_history_page.dart';  // ← IMPORT CORREGIDO

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

      // ✅ AÑADE ESTA RUTA - PERSONA 5
      case '/order-history':
        return MaterialPageRoute(builder: (_) => OrderHistoryPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Página no encontrada")),
          ),
        );
    }
  }
}