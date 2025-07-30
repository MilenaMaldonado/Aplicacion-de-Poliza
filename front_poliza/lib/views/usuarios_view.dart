import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuarios_viewmodel.dart';
import 'login_view.dart';

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
                  leading: IconButton(
                    key: const ValueKey('backButton'),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Regresar',
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  actions: [
                    IconButton(
                      key: const ValueKey('refreshButton'),
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Actualizar',
                      onPressed: () => vm.fetchUsuarios(),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        key: const ValueKey('menuButton'),
                        icon: const Icon(Icons.menu),
                        tooltip: 'Menú',
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                ),
                endDrawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Color(0xFF1565C0)),
                        child: Center(child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 22))),
                      ),
                      ListTile(
                        key: const ValueKey('logoutButton'),
                        leading: const Icon(Icons.logout),
                        title: const Text('Cerrar sesión'),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginView()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
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
                              return Card(
                                child: ListTile(
                                  key: ValueKey('usuarioTile_${u.nombreCompleto}'),
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                    child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                                  ),
                                  title: Text(u.nombreCompleto, style: Theme.of(context).textTheme.titleLarge),
                                  subtitle: Row(
                                    children: [
                                      const Icon(Icons.cake, size: 18, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('Edad: ${u.edad}', style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ),
                                  trailing: u.automovilIds != null && u.automovilIds!.isNotEmpty
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.directions_car, color: Colors.orange),
                                            const SizedBox(width: 4),
                                            Text('${u.automovilIds!.length}'),
                                          ],
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
              );
            },
          ),
        );
      }
    }
