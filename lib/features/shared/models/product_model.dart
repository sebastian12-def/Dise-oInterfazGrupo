
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int stock;

  Product({
    required this.id,
    required this.name,
    this.description = '', // ← Valor por defecto vacío
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0, // ← Valor por defecto
    this.stock = 0,    // ← Valor por defecto
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '', // Mantener vacío
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '', // Soporta ambos nombres
      category: json['category'] ?? 'General',
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? json['quantity'] ?? 0, // Soporta ambos nombres
    );
  }
}
class Category {
  final String id;
  final String name;
  final String iconUrl;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.productCount = 0,
  });
}
