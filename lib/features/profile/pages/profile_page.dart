import 'package:flutter/material.dart';
// Importar el servicio de autenticación
import '../../../core/api/auth_service.dart';
import 'dart:convert';

/// Pantalla principal del PERFIL.
/// Aquí el usuario ve su información personal obtenida de la base de datos.
/// Los cambios se hacen en pantallas aparte (buenas prácticas).
class ProfilePage extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfilePage({super.key, this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variable para almacenar los datos del usuario
  Map<String, dynamic>? userData;
  // Variable para controlar si está cargando
  bool isLoading = true;
  // Variable para almacenar mensajes de error
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Cargar los datos del usuario cuando se abre la pantalla
    _loadUserProfile();
  }

  /// Función para cargar los datos del usuario desde la base de datos
  Future<void> _loadUserProfile() async {
    try {
      // Mostrar log de depuración
      print('📱 Cargando perfil del usuario...');
      
      // Primero, intentar obtener los datos del backend
      final result = await AuthService.getProfile();

      // Mostrar log con la respuesta
      print('📊 Respuesta del backend: $result');

      // Actualizar el estado con los datos recibidos
      if (mounted) {
        setState(() {
          // Si la llamada fue exitosa, guardar los datos del usuario
          if (result['success'] == true) {
            userData = result['usuario'];
            errorMessage = null;
            print('✅ Datos cargados correctamente: $userData');
          } else {
            // Si hubo error, intentar cargar datos locales como fallback
            print('⚠️ Error del backend, intentando cargar datos locales...');
            // No mostrar error inmediatamente, esperar a cargar datos locales
          }
          // Cambiar el estado de carga a falso
          isLoading = false;
        });
      }
    } catch (e) {
      // Si hay excepción, mostrar error
      print('🔥 Excepción en getProfile: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    // Si no hay datos del backend, intentar cargar datos locales
    if (userData == null && mounted) {
      try {
        print('🔄 Buscando datos locales guardados...');
        final localData = await AuthService.getUserDataLocal();
        
        if (localData != null && mounted) {
          print('✅ Datos locales encontrados: $localData');
          setState(() {
            userData = localData;
            errorMessage = null;
          });
        } else if (mounted) {
          // Si no hay datos locales ni del backend
          setState(() {
            errorMessage = 'No se pudieron cargar los datos del perfil';
          });
        }
      } catch (e) {
        print('🔥 Error al cargar datos locales: $e');
        if (mounted) {
          setState(() {
            errorMessage = 'Error: $e';
            userData = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),

      // El contenido principal va dentro de un padding
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildContent(),
      ),
    );
  }

  /// Construir el contenido según el estado (cargando, error, o datos del usuario)
  Widget _buildContent() {
    // Si está cargando, mostrar un indicador de carga
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Si hay error, mostrar el mensaje de error
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Mostrar información de depuración
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                '⚠️ Backend URL: http://localhost:3000/api/auth\n\n'
                '🔍 Verifica que:\n'
                '1. El backend esté corriendo\n'
                '2. La URL sea correcta\n'
                '3. Haya datos en la base de datos\n'
                '4. El token esté guardado',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Botón para reintentar cargar los datos
                setState(() => isLoading = true);
                _loadUserProfile();
              },
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    // Si los datos se cargaron correctamente, mostrar la información del usuario
    if (userData != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // FOTO DE PERFIL - Mostrar avatar_url si existe, sino default
            CircleAvatar(
              radius: 50,
              backgroundImage: userData!['avatar_url'] != null && userData!['avatar_url'].isNotEmpty
                  ? NetworkImage(userData!['avatar_url'])
                  : const AssetImage('assets/user.png') as ImageProvider,
            ),

            const SizedBox(height: 20),

            // NOMBRE DEL USUARIO (Obtenido de la base de datos)
            Text(
              userData!['nombre'] ?? userData!['name'] ?? 'Sin nombre',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // EMAIL DEL USUARIO (Obtenido de la base de datos)
            Text(
              userData!['email'] ?? 'Sin email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // DEBUG: Mostrar todos los datos recibidos del backend
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DEBUG - Datos recibidos del backend:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    jsonEncode(userData),
                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // OPCIONES DEL PERFIL
            // OPCIÓN PARA ACTUALIZAR PERFIL
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Cambiar Nombre"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showUpdateNameDialog(context),
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Cambiar Email"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showUpdateEmailDialog(context),
            ),

            // OPCIÓN PARA ELIMINAR CUENTA
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Eliminar Cuenta",
                  style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showDeleteAccountDialog(context),
            ),

            const SizedBox(height: 20),

            // BOTÓN PARA CERRAR SESIÓN
            ElevatedButton.icon(
              onPressed: () async {
                // Cerrar sesión eliminando el token guardado
                await AuthService.logout();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sesión cerrada correctamente"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Llamar el callback para actualizar el estado del padre
                  widget.onLogout?.call();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar Sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Si no hay datos ni error, mostrar un mensaje
    return const Center(
      child: Text("No hay datos disponibles"),
    );
  }

  /// Mostrar diálogo para actualizar solo el nombre
  void _showUpdateNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _UpdateNameDialog(
        currentName: userData?['nombre'] ?? '',
        onUpdated: _loadUserProfile,
      ),
    );
  }

  /// Mostrar diálogo para actualizar solo el email
  void _showUpdateEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _UpdateEmailDialog(
        currentEmail: userData?['email'] ?? '',
        onUpdated: _loadUserProfile,
      ),
    );
  }

  /// Mostrar diálogo de confirmación para eliminar la cuenta
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _DeleteAccountDialog(onLogout: widget.onLogout),
    );
  }
}

/// Diálogo para actualizar solo el nombre del usuario
class _UpdateNameDialog extends StatefulWidget {
  final String currentName;
  final VoidCallback? onUpdated;

  const _UpdateNameDialog({
    required this.currentName,
    this.onUpdated,
  });

  @override
  State<_UpdateNameDialog> createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends State<_UpdateNameDialog> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cambiar Nombre"),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: "Nuevo nombre",
          border: OutlineInputBorder(),
          hintText: "Ingresa tu nuevo nombre",
        ),
        onChanged: (_) {
          setState(() {}); // Rebuild para habilitar/deshabilitar botón
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _isLoading || _nameController.text.trim().isEmpty
              ? null
              : () async {
                  setState(() => _isLoading = true);

                  try {
                    final result = await AuthService.updateProfile(
                      nombre: _nameController.text.trim(),
                    );

                    setState(() => _isLoading = false);

                    if (context.mounted) {
                      if (result['success'] == true) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Nombre actualizado correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Recargar los datos del perfil
                        if (widget.onUpdated != null) {
                          widget.onUpdated!();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                result['error'] ?? "Error al actualizar nombre"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Guardar"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

/// Diálogo para actualizar solo el email del usuario
class _UpdateEmailDialog extends StatefulWidget {
  final String currentEmail;
  final VoidCallback? onUpdated;

  const _UpdateEmailDialog({
    required this.currentEmail,
    this.onUpdated,
  });

  @override
  State<_UpdateEmailDialog> createState() => _UpdateEmailDialogState();
}

class _UpdateEmailDialogState extends State<_UpdateEmailDialog> {
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cambiar Email"),
      content: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: "Nuevo email",
          border: OutlineInputBorder(),
          hintText: "tu@email.com",
        ),
        onChanged: (_) {
          setState(() {}); // Rebuild para habilitar/deshabilitar botón
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _isLoading ||
                  _emailController.text.trim().isEmpty ||
                  _validateEmail(_emailController.text) != null
              ? null
              : () async {
                  setState(() => _isLoading = true);

                  try {
                    final result = await AuthService.updateProfile(
                      email: _emailController.text.trim(),
                    );

                    setState(() => _isLoading = false);

                    if (context.mounted) {
                      if (result['success'] == true) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email actualizado correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Recargar los datos del perfil
                        if (widget.onUpdated != null) {
                          widget.onUpdated!();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                result['error'] ?? "Error al actualizar email"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Guardar"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

/// Diálogo para eliminar la cuenta del usuario
class _DeleteAccountDialog extends StatefulWidget {
  final VoidCallback? onLogout;

  const _DeleteAccountDialog({this.onLogout});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("⚠️ Eliminar cuenta"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Esta acción es irreversible. Se eliminará tu cuenta y todos tus datos.",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 16),
          const Text(
            "Ingresa tu contraseña para confirmar:",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Contraseña",
              border: OutlineInputBorder(),
              hintText: "Tu contraseña",
            ),
            onChanged: (_) {
              setState(() {}); // Rebuild para habilitar/deshabilitar botón
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _isLoading || _passwordController.text.isEmpty
              ? null
              : () async {
                  setState(() => _isLoading = true);

                  try {
                    final result = await AuthService.deleteAccount(
                      password: _passwordController.text,
                    );

                    setState(() => _isLoading = false);

                    if (context.mounted) {
                      if (result['success'] == true) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cuenta eliminada correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Llamar callback para actualizar estado
                        widget.onLogout?.call();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['error'] ?? "Error al eliminar cuenta",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  "Eliminar Cuenta",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
