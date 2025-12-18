// lib/core/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/shared/models/product_model.dart';

class ApiService {

  // Para Android emulador: 'http://10.0.2.2:5432/api'
  // Para web: 'http://localhost:5432/api' 
  static const String baseUrl = 'http://localhost:3000/api';
  // ======================================
  
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtiene todos los productos desde tu backend Node.js
  Future<List<Product>> getProducts() async {
    try {
      print('🌍 Conectando a: $baseUrl/products');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: _headers,
      );
      
      print('📊 Status Code: ${response.statusCode}');
      print('📦 Respuesta: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'] ?? false;
        final List<dynamic> data = responseData['data'] ?? [];
        final String message = responseData['message'] ?? '';
        
        print('✅ Success: $success');
        print('📦 Mensaje: $message');
        print('🛒 Productos recibidos: ${data.length}');
        
        if (!success) {
          throw Exception('API returned success: false - $message');
        }
        
        // Convertir cada item del array "data" a Product
        return data.map((item) {
          return Product(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Sin nombre',
            description: '', // Tu backend no envía descripción
            price: _parsePrice(item['price']), // Convertir 189900 → 1899.00
            imageUrl: item['image_url'] ?? '',
            category: _inferCategoryFromName(item['name']), // Inferir de nombre
            rating: 4.0, // Valor por defecto (tu backend no envía rating)
            stock: (item['quantity'] ?? 0).toInt(),
          );
        }).toList();
      } else {
        throw Exception('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('🔥 Error en getProducts: $e');
      rethrow;
    }
  }

  /// Convierte precio de centavos/pesos a decimal (189900 → 1899.00)
  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    
    final numPrice = (price is int) ? price.toDouble() : (price as num).toDouble();
    
    // Si el precio es muy grande (como 189900), probablemente está en centavos/pesos
    // Dividir por 100 para mostrar en formato decimal
    if (numPrice > 1000) {
      return numPrice / 100;
    }
    
    return numPrice;
  }

  /// Inferir categoría basada en el nombre del producto
  String _inferCategoryFromName(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('reloj') || 
        lowerName.contains('smart') ||
        lowerName.contains('tecnolog')) {
      return 'Electrónica';
    } else if (lowerName.contains('zapat') || 
               lowerName.contains('running') ||
               lowerName.contains('deportiv')) {
      return 'Deportes';
    } else if (lowerName.contains('jeans') || 
               lowerName.contains('camiseta') ||
               lowerName.contains('fit') ||
               lowerName.contains('ropa')) {
      return 'Ropa';
    } else if (lowerName.contains('libro') || 
               lowerName.contains('lectura')) {
      return 'Libros';
    } else if (lowerName.contains('juguete') || 
               lowerName.contains('juego')) {
      return 'Juguetes';
    }
    
    return 'General';
  }

  /// Obtiene un producto por ID
  Future<Product> getProductById(String id) async {
    try {
      print('🔍 Buscando producto ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final item = responseData['data'];
          
          return Product(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? '',
            description: '',
            price: _parsePrice(item['price']),
            imageUrl: item['image_url'] ?? '',
            category: _inferCategoryFromName(item['name']),
            rating: 4.0,
            stock: (item['quantity'] ?? 0).toInt(),
          );
        } else {
          throw Exception('Producto no encontrado');
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en getProductById: $e');
      rethrow;
    }
  }

  /// Crea un nuevo producto
  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: _headers,
        body: json.encode({
          'name': product.name,
          'price': (product.price * 100).toInt(), // Convertir a centavos
          'image_url': product.imageUrl,
          'quantity': product.stock,
          // Agregar más campos si tu backend los acepta
        }),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final item = responseData['data'];
          
          return Product(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? '',
            description: '',
            price: _parsePrice(item['price']),
            imageUrl: item['image_url'] ?? '',
            category: product.category,
            rating: product.rating,
            stock: (item['quantity'] ?? 0).toInt(),
          );
        } else {
          throw Exception('Error en creación: ${responseData['message']}');
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en createProduct: $e');
      rethrow;
    }
  }

  /// Actualiza un producto existente
  Future<Product> updateProduct(String id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
        body: json.encode({
          'name': product.name,
          'price': (product.price * 100).toInt(),
          'image_url': product.imageUrl,
          'quantity': product.stock,
        }),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final item = responseData['data'];
          
          return Product(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? '',
            description: '',
            price: _parsePrice(item['price']),
            imageUrl: item['image_url'] ?? '',
            category: product.category,
            rating: product.rating,
            stock: (item['quantity'] ?? 0).toInt(),
          );
        } else {
          throw Exception('Error en actualización: ${responseData['message']}');
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en updateProduct: $e');
      rethrow;
    }
  }

  /// Elimina un producto
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en deleteProduct: $e');
      rethrow;
    }
  }
}