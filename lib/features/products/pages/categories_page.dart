import 'package:flutter/material.dart';
import '../../shared/models/category_model.dart';
import 'product_list_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // Datos de ejemplo de categorías - AHORA usando Category del modelo
  static final List<Category> categories = [
    Category(
      id: '1',
      name: 'Electrónica',
      iconUrl: '',
      productCount: 45,
    ),
    Category(
      id: '2',
      name: 'Ropa',
      iconUrl: '',
      productCount: 120,
    ),
    Category(
      id: '3',
      name: 'Hogar',
      iconUrl: '',
      productCount: 78,
    ),
    Category(
      id: '4',
      name: 'Deportes',
      iconUrl: '',
      productCount: 56,
    ),
    Category(
      id: '5',
      name: 'Libros',
      iconUrl: '',
      productCount: 200,
    ),
    Category(
      id: '6',
      name: 'Juguetes',
      iconUrl: '',
      productCount: 89,
    ),
    Category(
      id: '7',
      name: 'Alimentos',
      iconUrl: '',
      productCount: 150,
    ),
    Category(
      id: '8',
      name: 'Belleza',
      iconUrl: '',
      productCount: 95,
    ),
    Category(
      id: '9',
      name: 'Salud',
      iconUrl: '',
      productCount: 67,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navegar a búsqueda
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Explora por categoría',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Encuentra productos en tu categoría favorita',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            // Grid de categorías
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryTile(
                    category: category,
                    onTap: () {
                      // Ahora pasa la categoría seleccionada
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListPage(
                            category: category, // ← ¡PASA LA CATEGORÍA!
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.category,
    this.onTap,
  });

  // Mapeo de nombres de categoría a iconos y colores
  Map<String, dynamic> _getCategoryStyle(String name) {
    switch (name.toLowerCase()) {
      case 'electrónica':
        return {'icon': Icons.devices, 'color': Colors.blue};
      case 'ropa':
        return {'icon': Icons.checkroom, 'color': Colors.pink};
      case 'hogar':
        return {'icon': Icons.home, 'color': Colors.orange};
      case 'deportes':
        return {'icon': Icons.sports_soccer, 'color': Colors.green};
      case 'libros':
        return {'icon': Icons.book, 'color': Colors.brown};
      case 'juguetes':
        return {'icon': Icons.toys, 'color': Colors.purple};
      case 'alimentos':
        return {'icon': Icons.restaurant, 'color': Colors.red};
      case 'belleza':
        return {'icon': Icons.face, 'color': Colors.teal};
      case 'salud':
        return {'icon': Icons.health_and_safety, 'color': Colors.cyan};
      default:
        return {'icon': Icons.category, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(category.name);
    final icon = style['icon'] as IconData;
    final color = style['color'] as Color;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              // Nombre
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Cantidad de productos
              Text(
                '${category.productCount} productos',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ¡ELIMINADA la clase CategoryData! Ahora usamos Category del modelo