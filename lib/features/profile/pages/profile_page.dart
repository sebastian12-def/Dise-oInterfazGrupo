import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/// Pantalla principal del PERFIL.
/// Aquí el usuario ve su información personal.
/// Esta pantalla NO cambia datos, solo los muestra.
/// Los cambios se hacen en pantallas aparte (buenas prácticas).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
      ),

      // El contenido principal va dentro de un padding
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FOTO DE PERFIL
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user.png'),
            ),

            const SizedBox(height: 20),

            // NOMBRE DEL USUARIO (Ejemplo estático)
            const Text(
              "Juan Pérez",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // EMAIL DEL USUARIO
            const Text(
              "juan@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // OPCIONES DEL PERFIL
            // Cada opción te lleva a otra pantalla del módulo
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Cambiar Email"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navega a la pantalla para cambiar email
                context.push('/profile/email');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Seleccionar Género"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push('/profile/gender');
              },
            ),

            const Spacer(),

            // BOTÓN CERRAR SESIÓN
            ElevatedButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                /// En una app real:
                /// - Limpias sesión
                /// - Vuelves a login
                context.go('/login');
              },
              child: const Text("Cerrar Sesión"),
            )
          ],
        ),
      ),
    );
  }
}
