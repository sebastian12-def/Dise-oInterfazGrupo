import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../../shared/models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  final Category? category;
  
  const ProductListPage({
    super.key,
    this.category,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _error = '';
  String? selectedCategory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      selectedCategory = widget.category!.name;
    }
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _error = '';
    });

    try {
      final products = await _apiService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar productos: $e';
        _isLoading = false;
      });
      print(_error);
    }
  }

  List<Product> get filteredProducts {
    return _products.where((product) {
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
            // Navegar al carrito
          },
        ),
      ),
    );
  }

  List<Category> _getCategories() {
    final categories = <String, int>{};
    
    for (var product in _products) {
      categories[product.category] = (categories[product.category] ?? 0) + 1;
    }
    
    final categoryList = [
      Category(id: '0', name: 'Todos', iconUrl: '', productCount: _products.length),
    ];
    
    categories.forEach((name, count) {
      categoryList.add(
        Category(id: name, name: name, iconUrl: '', productCount: count),
      );
    });
    
    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category != null ? widget.category!.name : 'Productos',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navegar al carrito
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'Actualizar productos',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando productos...'),
                ],
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProducts,
                  child: CustomScrollView(
                    slivers: [
                      // Barra de búsqueda
                      SliverToBoxAdapter(
                        child: Padding(
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
                      ),
                      // Lista de categorías (solo si NO viene de categories_page)
                      if (widget.category == null)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  itemCount: _getCategories().length,
                                  itemBuilder: (context, index) {
                                    final category = _getCategories()[index];
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
                            ],
                          ),
                        ),
                      // Contador de resultados
                      SliverToBoxAdapter(
                        child: Padding(
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
                                  // Implementar filtros
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Grid de productos o mensaje vacío
                      if (filteredProducts.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _products.isEmpty
                                      ? 'No hay productos disponibles'
                                      : 'No se encontraron productos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (_products.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: _loadProducts,
                                      child: const Text('Cargar productos'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
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
                              childCount: filteredProducts.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}