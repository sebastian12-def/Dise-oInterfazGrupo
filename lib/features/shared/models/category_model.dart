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