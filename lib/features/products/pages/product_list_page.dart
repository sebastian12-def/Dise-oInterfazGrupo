import 'package:flutter/material.dart';
import '../../shared/models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String? selectedCategory;
  String searchQuery = '';

  // Datos de ejemplo - En producción vendrían de una API o base de datos
  final List<Category> categories = [
    Category(id: '1', name: 'Todos', iconUrl: '', productCount: 12),
    Category(id: '2', name: 'Electrónica', iconUrl: '', productCount: 5),
    Category(id: '3', name: 'Ropa', iconUrl: '', productCount: 4),
    Category(id: '4', name: 'Hogar', iconUrl: '', productCount: 3),
    Category(id: '5', name: 'Deportes', iconUrl: '', productCount: 2),
  ];

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Smartphone Premium',
      description: 'Smartphone de última generación con cámara de 48MP, pantalla AMOLED de 6.7 pulgadas y batería de larga duración.',
      price: 1199.99,
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop',
      category: 'Electrónica',
      rating: 4.9,
      stock: 15,
    ),
    Product(
      id: '2',
      name: 'Laptop Profesional',
      description: 'Laptop ultradelgada con procesador de última generación, 16GB RAM, 512GB SSD. Perfecta para trabajo.',
      price: 1099.99,
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop',
      category: 'Electrónica',
      rating: 4.8,
      stock: 8,
    ),
    Product(
      id: '3',
      name: 'Chaqueta de Hombre',
      description: 'Chaqueta casual de algodón con ajuste slim, perfecta para cualquier ocasión.',
      price: 55.99,
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&h=300&fit=crop',
      category: 'Ropa',
      rating: 4.7,
      stock: 25,
    ),
    Product(
      id: '4',
      name: 'Camiseta Casual',
      description: 'Camiseta de algodón 100% con diseño slim fit, suave y cómoda.',
      price: 22.99,
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300&h=300&fit=crop',
      category: 'Ropa',
      rating: 4.6,
      stock: 50,
    ),
    Product(
      id: '5',
      name: 'Reloj Inteligente',
      description: 'Smartwatch con monitor de salud, GPS integrado y resistencia al agua.',
      price: 299.99,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
      category: 'Electrónica',
      rating: 4.5,
      stock: 30,
    ),
    Product(
      id: '6',
      name: 'Lámpara Decorativa',
      description: 'Lámpara LED moderna con luz regulable y diseño minimalista para el hogar.',
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=300&h=300&fit=crop',
      category: 'Hogar',
      rating: 4.9,
      stock: 5,
    ),
    Product(
      id: '7',
      name: 'Mochila Deportiva',
      description: 'Mochila resistente al agua con compartimentos múltiples, ideal para deportes.',
      price: 109.99,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop',
      category: 'Deportes',
      rating: 4.4,
      stock: 40,
    ),
    Product(
      id: '8',
      name: 'Auriculares Premium',
      description: 'Auriculares inalámbricos con cancelación de ruido y sonido de alta fidelidad.',
      price: 149.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
      category: 'Electrónica',
      rating: 4.8,
      stock: 12,
    ),
  ];

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesCategory = selectedCategory == null ||
          selectedCategory == 'Todos' ||
          product.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onAddToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () {
            // Navegar al carrito - será implementado por Persona 4
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navegar al carrito - será implementado por Persona 4
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Lista de categorías horizontal
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  isSelected: selectedCategory == category.name ||
                      (selectedCategory == null && category.name == 'Todos'),
                  onTap: () {
                    setState(() {
                      selectedCategory = category.name;
                    });
                  },
                );
              },
            ),
          ),
          const Divider(),
          // Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredProducts.length} productos encontrados',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Implementar filtros adicionales
                  },
                ),
              ],
            ),
          ),
          // Grid de productos
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron productos',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                                onAddToCart: () => _onAddToCart(product),
                              ),
                            ),
                          );
                        },
                        onAddToCart: () => _onAddToCart(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
