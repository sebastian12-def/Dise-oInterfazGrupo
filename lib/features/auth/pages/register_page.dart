import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_button.dart';
// Importar el servicio de autenticación
import '../../../core/api/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onNavigateToLogin;
  final VoidCallback? onLoginSuccess;

  const RegisterPage({
    super.key,
    this.onNavigateToLogin,
    this.onLoginSuccess,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu nombre';
    }
    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una contraseña';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    // Verificar que el usuario haya aceptado los términos
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acepta los términos y condiciones')),
      );
      return;
    }

    // Validar que todos los campos del formulario sean correctos
    if (!_formKey.currentState!.validate()) return;

    // Mostrar indicador de carga mientras se envían los datos al backend
    setState(() => _isLoading = true);

    try {
      // Llamar al servicio de autenticación para registrar el usuario
      // Se envían: nombre, email, contraseña y género (género es opcional)
      final result = await AuthService.register(
        nombre: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: 'male', // Puedes cambiar esto o hacerlo dinámico
      );

      // Ocultar indicador de carga
      setState(() => _isLoading = false);

      if (mounted) {
        // Si el registro fue exitoso (success = true)
        if (result['success'] == true) {
          // El token se guardó automáticamente en el dispositivo
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Registro exitoso! Bienvenido'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navegar a la pantalla de login o de inicio
          if (widget.onNavigateToLogin != null) {
            widget.onNavigateToLogin!.call();
          } else {
            Navigator.pop(context);
          }
        } else {
          // Si hubo error (por ejemplo, email ya existe)
          // Mostrar el mensaje de error que devolvió el backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Error en el registro'),
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
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(
                  Icons.person_add_rounded,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Regístrate',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea tu cuenta para comenzar',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                InputField(
                  controller: _nameController,
                  labelText: 'Nombre completo',
                  hintText: 'Juan Pérez',
                  prefixIcon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: _validateName,
                ),
                const SizedBox(height: 16),

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
                  labelText: 'Contraseña',
                  validator: _validatePassword,
                  showStrengthIndicator: true,
                ),
                const SizedBox(height: 16),

                PasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmar contraseña',
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() => _acceptTerms = value ?? false);
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _acceptTerms = !_acceptTerms);
                        },
                        child: const Text('Acepto los términos y condiciones'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                AuthButton(
                  text: 'Registrarse',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        if (widget.onNavigateToLogin != null) {
                          widget.onNavigateToLogin!.call();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Inicia sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
