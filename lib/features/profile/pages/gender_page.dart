import 'package:flutter/material.dart';

/// Pantalla para seleccionar el GÉNERO.
/// Usa RadioListTile, que es ideal para seleccionar UNA opción.
/// El usuario elige y se guarda.
class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String gender = "masculino";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Género"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          RadioListTile(
            value: "masculino",
            groupValue: gender,
            title: const Text("Masculino"),
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
          RadioListTile(
            value: "femenino",
            groupValue: gender,
            title: const Text("Femenino"),
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
          RadioListTile(
            value: "otro",
            groupValue: gender,
            title: const Text("Otro"),
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              /// Simula actualización en base de datos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Género actualizado: $gender')),
              );

              /// Vuelve al perfil
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
