# 🛍️ E-Commerce App - Diseño de Interfaz Grupo

Una aplicación de e-commerce moderna construida con **Flutter** que demuestra buenas prácticas de diseño UI/UX, arquitectura limpia y gestión de estado.

## 📱 Descripción del Proyecto

Esta es una aplicación de comercio electrónico diseñada para que los usuarios puedan:
- ✅ Navegar y explorar productos
- ✅ Filtrar por categorías
- ✅ Agregar productos al carrito
- ✅ Procesar pagos
- ✅ Ver historial de compras
- ✅ Gestionar su perfil de usuario
- ✅ Cambiar email y preferencias

### 🎯 Características Principales

**Autenticación:**
- Sistema de login/registro con validación
- Recuperación de contraseña
- Gestión de sesiones

**Catálogo de Productos:**
- Visualización de productos con imágenes
- Filtrado por categorías
- Búsqueda de productos
- Detalles completos de cada producto
- Calificaciones y reseñas

**Carrito de Compras:**
- Agregar/remover productos
- Editar cantidades
- Cálculo automático de totales
- Visualización clara del carrito

**Proceso de Compra:**
- Selección de método de pago
- Resumen de pago
- Confirmación de orden
- Historial de compras

**Perfil de Usuario:**
- Visualización de información personal
- Editar perfil (nombre, teléfono)
- Cambiar email
- Seleccionar género/preferencias
- Eliminar cuenta
- Cerrar sesión

**Navegación:**
- Bottom navigation bar con 4 secciones
- Transiciones suaves entre pantallas
- Interfaz intuitiva y responsive

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada de la app
│
├── features/                          # Características principales
│   ├── auth/                         # Autenticación
│   │   ├── pages/
│   │   │   ├── auth_entry_page.dart
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   └── reset_password_page.dart
│   │   └── widgets/
│   │       ├── input_field.dart
│   │       ├── password_field.dart
│   │       └── auth_button.dart
│   │
│   ├── products/                     # Catálogo de productos
│   │   ├── pages/
│   │   │   ├── product_list_page.dart
│   │   │   ├── product_detail_page.dart
│   │   │   └── categories_page.dart
│   │   └── widgets/
│   │       ├── product_card.dart
│   │       └── category_card.dart
│   │
│   ├── cart/                         # Carrito de compras
│   │   ├── pages/
│   │   │   ├── cart_page.dart
│   │   │   ├── payment_method_page.dart
│   │   │   ├── payment_summary_page.dart
│   │   │   └── order_completed_page.dart
│   │   ├── widgets/
│   │   │   ├── cart_item_widget.dart
│   │   │   └── cart_total_widget.dart
│   │   ├── models/
│   │   │   └── cart_item_model.dart
│   │   └── router/
│   │       └── app_router.dart
│   │
│   ├── orders/                       # Historial de órdenes
│   │   ├── pages/
│   │   │   └── orders_page.dart
│   │   └── widgets/
│   │       └── order_card_widget.dart
│   │
│   ├── profile/                      # Perfil de usuario
│   │   └── pages/
│   │       ├── profile_page.dart
│   │       ├── change_email_page.dart
│   │       └── gender_page.dart
│   │
│   └── shared/                       # Código compartido
│       └── models/
│           ├── product_model.dart
│           └── order_model.dart
│
├── services/                         # Servicios (BD, API, etc)
│   └── mock_database_service.dart   # Simulación de BD para desarrollo
│
└── assets/                           # Recursos estáticos
    ├── images/
    └── icons/
```

---

## 🚀 Instalación y Configuración

### Requisitos Previos
- **Flutter**: v3.0 o superior
- **Dart**: v3.0 o superior
- **IDE**: VS Code, Android Studio o Xcode

### Pasos para Instalar

1. **Clonar el repositorio**
```bash
git clone https://github.com/sebastian12-def/Dise-oInterfazGrupo.git
cd Dise-oInterfazGrupo
```

2. **Obtener dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

4. **Compilar para producción (opcional)**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🔧 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^12.0.0              # Navegación avanzada
  cupertino_icons: ^1.0.2         # Iconos iOS
```

---

## 📊 Flujo de la Aplicación

```
┌─────────────────┐
│   SplashScreen  │
└────────┬────────┘
         │
    ┌────▼────┐
    │ Logueado │
    └─┬────┬──┘
      │    │
  NO  │    │  SÍ
  ────┘    └─────┐
      │          │
      ▼          ▼
  ┌────────┐  ┌─────────────────┐
  │ Login  │  │ MainNavigation  │
  │Register│  ├─────────────────┤
  └────────┘  │ 1. Productos    │
              │ 2. Categorías   │
              │ 3. Carrito      │
              │ 4. Perfil       │
              └─────────────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
    ┌────────┐ ┌────────┐ ┌────────┐
    │ Detalle│ │ Carrito│ │ Perfil │
    │Producto│ │ Pago   │ │ Editar │
    └────────┘ └────────┘ └────────┘
```

---

## 🎨 Paleta de Colores

- **Primario**: Deep Purple (`Colors.deepPurple`)
- **Secundario**: Gray (`Colors.grey[700]`)
- **Accent**: Teal, Amber, Blue
- **Fondo**: White / Gray[50]
- **Texto**: Black87 / Gray[700]

---

## 👤 Gestión de Usuario

### Flujo de Autenticación

1. **Registro:**
   - Email válido
   - Contraseña mínimo 6 caracteres
   - Confirmación de contraseña

2. **Login:**
   - Validación de email y contraseña
   - Mensaje de éxito
   - Redirección a pantalla principal

3. **Perfil:**
   - Ver información personal
   - Editar nombre y teléfono
   - Cambiar email
   - Seleccionar género
   - Eliminar cuenta
   - Cerrar sesión

---

## 🛒 Gestión del Carrito

```dart
// Ejemplo de uso
await MockDatabaseService.addToCart(
  productId: '1',
  quantity: 2,
);

// Obtener carrito
List<Map<String, dynamic>> cart = await MockDatabaseService.getCart();

// Crear orden
await MockDatabaseService.createOrder(
  items: cartItems,
  shippingAddress: '123 Main St',
  paymentMethod: 'credit_card',
);
```

---

## 🏗️ Arquitectura

### Patrón de Diseño: Clean Architecture + MVVM

**Layers:**
- **Presentation**: Páginas, widgets y UI
- **Domain**: Lógica de negocio
- **Data**: Fuentes de datos (mock/BD)

**Estado:**
- Manejo mediante `setState()` en StatefulWidgets
- Posibilidad de migrar a Provider/Riverpod

---

## 📚 Modelos de Datos

### Product
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int stock;
}
```

### Order
```dart
class Order {
  final String id;
  final DateTime date;
  final double total;
  final String status;  // pending, completed, cancelled
  final List<OrderItem> items;
}
```

### CartItem
```dart
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String image;
}
```

---

## 🧪 Datos Mock para Desarrollo

La aplicación incluye datos simulados en `services/mock_database_service.dart`:

- **8 Productos** de ejemplo
- **4 Categorías**
- **3 Órdenes** en historial
- **1 Usuario** de prueba

Para cambiar los datos, edita directamente el archivo mock o conecta una BD real.

---

## 🔐 Seguridad (Notas)

⚠️ **Esta es una aplicación de demostración.**

Para producción, implementar:
- ✅ Autenticación real (Firebase, Supabase, etc)
- ✅ Encriptación de datos sensibles
- ✅ HTTPS para comunicaciones
- ✅ Tokens JWT seguros
- ✅ Validación en backend

---

## 🌐 Integración con Supabase (Futuro)

Para conectar a una base de datos real:

1. Crear proyecto en [supabase.com](https://supabase.com)
2. Ejecutar script SQL (ver `SUPABASE_SETUP.md`)
3. Reemplazar `MockDatabaseService` con servicio real
4. Agregar autenticación de Supabase

Ejemplo:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

await Supabase.initialize(
  url: 'tu-url-supabase',
  anonKey: 'tu-clave-anonima',
);
```

---

## 📱 Pantallas Principales

### 1. Autenticación
- ✅ Login
- ✅ Registro
- ✅ Recuperación de contraseña

### 2. Productos
- ✅ Lista de productos
- ✅ Detalle de producto
- ✅ Filtro por categorías
- ✅ Búsqueda

### 3. Carrito
- ✅ Ver carrito
- ✅ Editar cantidades
- ✅ Elegir método de pago
- ✅ Resumen de pago
- ✅ Confirmación de orden

### 4. Perfil
- ✅ Información personal
- ✅ Editar perfil
- ✅ Cambiar email
- ✅ Seleccionar género
- ✅ Eliminar cuenta
- ✅ Cerrar sesión

---

## 🐛 Troubleshooting

### La app no compila
```bash
flutter clean
flutter pub get
flutter run
```

### Imágenes no carga
- Verificar conexión a internet
- Las imágenes son de Unsplash (requiere conexión)

### Error de navegación
- Asegúrate de tener `go_router` instalado
- Verifica las rutas en `app_router.dart`

---

## 📝 Notas de Desarrollo

- El proyecto usa **Material Design 3**
- Responsive para móvil (teléfono, tablet)
- Dark mode preparado (puede implementarse)
- Multiidioma listo (solo cambiar strings)

---

## 👥 Contribuidores

- **Sebastian12-def** - Desarrollo principal

---

## 📄 Licencia

Este proyecto es de código abierto y disponible bajo licencia MIT.

---

## 📞 Soporte

Para preguntas o problemas:
1. Abre un issue en el repositorio
2. Revisa la documentación existente
3. Consulta la guía de instalación

---

## 🎓 Recursos Útiles

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Dart Language](https://dart.dev/guides)
- [Go Router Package](https://pub.dev/packages/go_router)

---

**Última actualización**: 17 de Diciembre, 2025
**Versión**: 1.0.0
**Estado**: En desarrollo

