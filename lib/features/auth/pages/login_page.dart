import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_button.dart';
import 'register_page.dart';
import 'reset_password_page.dart';
// Importar el servicio de autenticación
import '../../../core/api/auth_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu email';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    // Validar que todos los campos sean correctos
    if (!_formKey.currentState!.validate()) return;

    // Mostrar indicador de carga mientras se envían los datos al backend
    setState(() => _isLoading = true);

    try {
      // Llamar al servicio de autenticación para iniciar sesión
      // Se envían: email y contraseña
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Ocultar indicador de carga
      setState(() => _isLoading = false);

      if (mounted) {
        // Si el login fue exitoso (success = true)
        if (result['success'] == true) {
          // El token se guardó automáticamente en el dispositivo
          // Llamar el callback para actualizar el estado del padre
          widget.onLoginSuccess?.call();

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Inicio de sesión exitoso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Si hubo error (credenciales incorrectas, usuario no existe, etc.)
          // Mostrar el mensaje de error que devolvió el backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Error al iniciar sesión'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Si hay error de conexión o excepción no manejada
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenido',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  InputField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'tu@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  PasswordField(
                    controller: _passwordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResetPasswordPage(),
                          ),
                        );
                      },
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  AuthButton(
                    text: 'Iniciar Sesión',
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterPage(
                                onLoginSuccess: widget.onLoginSuccess,
                                onNavigateToLogin: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(
                                        onLoginSuccess: widget.onLoginSuccess,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text('Regístrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
