import 'package:flutter/material.dart';

/// Pantalla que permite CAMBIAR el email.
/// Es un simple formulario con validación ligera.
/// Es buena práctica separar acciones en pantallas pequeñas.
class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar Email"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Campo donde el usuario escribe su nuevo email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Nuevo Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Botón guardar
            ElevatedButton(
              onPressed: () {
                /// VALIDACIÓN: revisa si hay algo escrito
                if (emailCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ingresa un email válido")),
                  );
                  return;
                }

                /// Aquí normalmente llamas a Firebase o API
                /// Para este proyecto solo simulamos
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Email actualizado a: ${emailCtrl.text}"),
                  ),
                );

                /// Vuelve al perfil
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
