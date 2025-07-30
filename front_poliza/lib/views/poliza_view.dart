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
  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23':
        return 'Mayor igual a 18 y menor a 23';
      case '23-55':
        return 'Mayor igual a 23 y menor a 55';
      default:
        return 'Mayor igual 55';
    }
  }
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
            onPressed: () {
              final usuario = vm.propietario.trim();
              if (usuario.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Primero ingresa el nombre del propietario.')),
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
            }, key: const ValueKey('txtPropietario')),
            const SizedBox(height: 12),
            _buildInput("Valor del seguro", _valorController, (val) {
              final number = double.tryParse(val) ?? 0;
              vm.valorSeguroAuto = number < 0 ? 0 : number;
              if (number < 0) _valorController.text = '0';
              vm.notifyListeners();
            }, keyboard: TextInputType.number, key: const ValueKey('txtValorSeguro')),
            const SizedBox(height: 12),
            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: ['A', 'B', 'C'].map((m) => Expanded(
                child: RadioListTile(
                  title: Text(m),
                  value: m,
                  groupValue: vm.modeloAuto,
                  onChanged: (val) {
                    vm.modeloAuto = val!;
                    vm.notifyListeners();
                  },
                  activeColor: Colors.teal,
                  dense: true,
                ),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Text("Edad propietario:", style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: ['18-23', '23-55', '55+'].map((e) => Expanded(
                child: RadioListTile(
                  title: Text(_textoEdad(e)),
                  value: e,
                  groupValue: vm.edadPropietario,
                  onChanged: (val) {
                    vm.edadPropietario = val!;
                    vm.notifyListeners();
                  },
                  activeColor: Colors.teal,
                  dense: true,
                ),
              )).toList(),
            ),
            const SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, (val) {
              final number = int.tryParse(val) ?? 0;
              vm.accidentes = number < 0 ? 0 : number;
              if (number < 0) _accidentesController.text = '0';
              vm.notifyListeners();
            }, keyboard: TextInputType.number, key: const ValueKey('txtAccidentes')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const ValueKey('btnCalcularPoliza'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  elevation: 4,
                ),
                onPressed: () async {
                  await vm.calcularPoliza();
                  FocusScope.of(context).unfocus();
                },
                child: const Text("CALCULAR PÓLIZA"),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                color: Colors.teal.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Costo total:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${vm.costoTotal.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, Function(String) onChanged, {TextInputType? keyboard, Key? key}) {
    final isNumeric = keyboard == TextInputType.number;
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboard,
      onChanged: (val) {
        if (isNumeric) {
          final filtered = val.replaceAll(RegExp(r'[^0-9.]'), '');
          if (filtered != val) {
            controller.text = filtered;
            controller.selection = TextSelection.fromPosition(TextPosition(offset: filtered.length));
            return;
          }
        }
        onChanged(val);
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
    );
  }
}