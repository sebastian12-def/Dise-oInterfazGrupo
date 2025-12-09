import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_total_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      name: "Nike Air Zoom Pegasus",
      price: 299.43,
      quantity: 1,
      imageUrl: "https://images.unsplash.com/photo-1600181952515-6c3b21fd7690",
    ),
    CartItem(
      name: "Nike Air Zoom Pegasus Red",
      price: 299.43,
      quantity: 1,
      imageUrl: "https://images.unsplash.com/photo-1600180758890-6d4dcb28ca54",
    ),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🛒 Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, i) {
                  final item = cartItems[i];
                  return CartItemWidget(
                    item: item,
                    onIncrease: () {
                      setState(() {
                        cartItems[i] = item.copyWith(
                          quantity: item.quantity + 1,
                        );
                      });
                    },
                    onDecrease: () {
                      if (item.quantity > 1) {
                        setState(() {
                          cartItems[i] = item.copyWith(
                            quantity: item.quantity - 1,
                          );
                        });
                      }
                    },
                    onRemove: () {
                      setState(() => cartItems.removeAt(i));
                    },
                  );
                },
              ),
            ),

            /// 💰 Total
            CartTotalWidget(
              subtotal: subtotal,
              shipping: 40,
              tax: 128,
            ),

            const SizedBox(height: 20),

            /// 🔘 BOTÓN CHECK OUT 
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment-method');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECE2F9),
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Check Out"),
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/order-history');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Ver historial"),
             ),
            ),
          ],
        ),
      ),
    );
  }
}
