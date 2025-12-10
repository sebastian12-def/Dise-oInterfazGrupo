import 'package:flutter/material.dart';
import 'product_list_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // Datos de ejemplo de categorías
  static final List<CategoryData> categories = [
    CategoryData(
      id: '1',
      name: 'Electrónica',
      description: 'Smartphones, laptops, audífonos y más',
      iconData: Icons.devices,
      color: Colors.blue,
      productCount: 45,
    ),
    CategoryData(
      id: '2',
      name: 'Ropa',
      description: 'Moda para hombres, mujeres y niños',
      iconData: Icons.checkroom,
      color: Colors.pink,
      productCount: 120,
    ),
    CategoryData(
      id: '3',
      name: 'Hogar',
      description: 'Decoración, muebles y accesorios',
      iconData: Icons.home,
      color: Colors.orange,
      productCount: 78,
    ),
    CategoryData(
      id: '4',
      name: 'Deportes',
      description: 'Equipamiento y ropa deportiva',
      iconData: Icons.sports_soccer,
      color: Colors.green,
      productCount: 56,
    ),
    CategoryData(
      id: '5',
      name: 'Libros',
      description: 'Ficción, educación y más',
      iconData: Icons.book,
      color: Colors.brown,
      productCount: 200,
    ),
    CategoryData(
      id: '6',
      name: 'Juguetes',
      description: 'Diversión para todas las edades',
      iconData: Icons.toys,
      color: Colors.purple,
      productCount: 89,
    ),
    CategoryData(
      id: '7',
      name: 'Alimentos',
      description: 'Productos frescos y empacados',
      iconData: Icons.restaurant,
      color: Colors.red,
      productCount: 150,
    ),
    CategoryData(
      id: '8',
      name: 'Belleza',
      description: 'Cosméticos y cuidado personal',
      iconData: Icons.face,
      color: Colors.teal,
      productCount: 95,
    ),
    CategoryData(
      id: '9',
      name: 'Salud',
      description: 'Vitaminas, suplementos y bienestar',
      iconData: Icons.health_and_safety,
      color: Colors.cyan,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListPage(),
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
  final CategoryData category;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                category.color.withOpacity(0.1),
                category.color.withOpacity(0.05),
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
                  color: category.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  category.iconData,
                  size: 32,
                  color: category.color,
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

// Clase auxiliar para los datos de categoría en esta página
class CategoryData {
  final String id;
  final String name;
  final String description;
  final IconData iconData;
  final Color color;
  final int productCount;

  CategoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconData,
    required this.color,
    required this.productCount,
  });
}
