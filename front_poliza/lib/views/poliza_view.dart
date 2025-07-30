
import 'usuarios_view.dart';
import 'poliza_resumen_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../viewmodels/poliza_viewmodel.dart';


class PolizaView extends StatefulWidget {
  const PolizaView({super.key});

  @override
  State<PolizaView> createState() => _PolizaViewState();
}

class _PolizaViewState extends State<PolizaView> {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    _accidentesController.dispose();
    _propietarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Póliza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Ver usuarios',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsuariosView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.summarize),
            tooltip: 'Resumen de pólizas',
            onPressed: () async {
              final usuario = vm.propietario.trim();
              if (usuario.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Primero ingresa el nombre del propietario.')),
                );
                return;
              }
              final exists = await _usuarioExiste(usuario);
              if (!exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario no encontrado')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PolizaResumenView(usuario: usuario),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInput("Propietario (Nombre Apellido)", _propietarioController, (val) {
              vm.propietario = val;
              vm.notifyListeners();
            }),
            // ...resto del widget tree y métodos ya definidos correctamente arriba...
          ],
        ),
      ),
    );
  }
  // ...métodos auxiliares ya definidos correctamente arriba...
}