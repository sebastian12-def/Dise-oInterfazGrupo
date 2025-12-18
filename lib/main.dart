import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'features/products/pages/product_list_page.dart';
import 'features/products/pages/categories_page.dart';
import 'features/auth/pages/auth_entry_page.dart';
import 'features/cart/pages/cart_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'features/profile/pages/change_email_page.dart';
import 'features/cart/providers/cart_provider.dart';
import 'core/api/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Verificar si el usuario ya tiene token guardado
    final token = await AuthService.getStoredToken();
    print('🔐 Token guardado: ${token != null ? "SÍ" : "NO"}');
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
        _isChecking = false;
        print('📊 Estado actualizado: _isLoggedIn = $_isLoggedIn, _isChecking = $_isChecking');
      });
    }
  }

  void _handleLoginSuccess() {
    print('✅ _handleLoginSuccess llamado');
    setState(() {
      _isLoggedIn = true;
      print('📊 Estado actualizado en _handleLoginSuccess: _isLoggedIn = $_isLoggedIn');
    });
  }

  void _handleLogout() {
    print('🚪 _handleLogout llamado');
    setState(() {
      _isLoggedIn = false;
      print('📊 Estado actualizado en _handleLogout: _isLoggedIn = $_isLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: _isChecking
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : _isLoggedIn
                ? MainNavigationPage(onLogout: _handleLogout)
                : AuthEntryPage(onLoginSuccess: _handleLoginSuccess),
      ),
    );
  }
}

// Página principal con navegación entre las pantallas de Persona 3
class MainNavigationPage extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigationPage({super.key, required this.onLogout});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProductListPage(),
      const CategoriesPage(),
      const CartPage(),
      ProfilePageWithLogout(onLogout: widget.onLogout),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categorías',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Widget envolvente para ProfilePage que maneja el logout
class ProfilePageWithLogout extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilePageWithLogout({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ProfilePage(onLogout: onLogout);
  }
}

// Wrapper para ChangeEmailPage con botón de retorno
class ChangeEmailPageWrapper extends StatelessWidget {
  const ChangeEmailPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: const ChangeEmailPage(),
    );
  }
}
