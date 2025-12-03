class Order {
  final String id;
  final DateTime date;
  final String status;
  final int itemCount;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.itemCount,
    required this.total,
    required this.items,

  });
}

class OrderItem {
  final String productName;
  final String? imageUrl;
  final double price;
  final int quantity;

  OrderItem({
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.quantity
  });
}