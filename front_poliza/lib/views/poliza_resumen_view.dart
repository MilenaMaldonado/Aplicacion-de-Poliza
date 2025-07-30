import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_resumen_viewmodel.dart';

class PolizaResumenView extends StatelessWidget {
  final String usuario;
  const PolizaResumenView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PolizaResumenViewModel()..fetchPolizasPorUsuario(usuario),
      child: Consumer<PolizaResumenViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Resumen de Pólizas'),
              backgroundColor: Colors.teal,
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                    ? Center(child: Text(vm.error!, style: const TextStyle(color: Colors.red)))
                    : vm.poliza == null
                        ? const Center(child: Text('No hay póliza para este usuario'))
                        : Padding(
                            padding: const EdgeInsets.all(24),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Propietario: ${vm.poliza!.propietario}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text('Modelo: ${vm.poliza!.modeloAuto}'),
                                    Text('Valor Seguro: ${vm.poliza!.valorSeguroAuto}'),
                                    Text('Edad: ${vm.poliza!.edadPropietario}'),
                                    Text('Accidentes: ${vm.poliza!.accidentes}'),
                                    const SizedBox(height: 12),
                                    Text('Costo Total: ${vm.poliza!.costoTotal}', style: const TextStyle(fontSize: 20, color: Colors.teal)),
                                  ],
                                ),
                              ),
                            ),
                          ),
          );
        },
      ),
    );
  }
}
