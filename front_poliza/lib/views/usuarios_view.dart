import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuarios_viewmodel.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsuariosViewModel()..fetchUsuarios(),
      child: Consumer<UsuariosViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de Usuarios'),
              backgroundColor: Colors.teal,
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                    ? Center(child: Text(vm.error!, style: const TextStyle(color: Colors.red)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.usuarios.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, i) {
                          final u = vm.usuarios[i];
                          return ListTile(
                            leading: CircleAvatar(child: Text(u.nombre.isNotEmpty ? u.nombre[0] : '?')),
                            title: Text('${u.nombre} ${u.apellido}'),
                            subtitle: Text(u.correo),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
