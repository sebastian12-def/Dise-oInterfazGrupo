import 'package:flutter/material.dart';
import '../../shared/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de categoría
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: category.iconUrl.isNotEmpty
                    ? Image.network(
                        category.iconUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            size: 30,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          );
                        },
                      )
                    : Icon(
                        _getCategoryIcon(category.name),
                        size: 30,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            // Nombre de categoría
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Cantidad de productos
            if (category.productCount > 0)
              Text(
                '${category.productCount} productos',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electrónica':
      case 'electronica':
        return Icons.devices;
      case 'ropa':
      case 'moda':
        return Icons.checkroom;
      case 'hogar':
        return Icons.home;
      case 'deportes':
        return Icons.sports_soccer;
      case 'libros':
        return Icons.book;
      case 'juguetes':
        return Icons.toys;
      case 'alimentos':
      case 'comida':
        return Icons.restaurant;
      case 'belleza':
        return Icons.face;
      case 'salud':
        return Icons.health_and_safety;
      default:
        return Icons.category;
    }
  }
}
