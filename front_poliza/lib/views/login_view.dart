import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'poliza_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Iniciar sesión'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.security_rounded, size: 60, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 16),
                          Text('Bienvenido', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 24),
                          TextField(
                            key: const ValueKey('txtUsuario'),
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (v) => vm.usuario = v,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            key: const ValueKey('txtPassword'),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            onChanged: (v) => vm.password = v,
                          ),
                          const SizedBox(height: 24),
                          if (vm.error != null)
                            Text(vm.error!, style: const TextStyle(color: Colors.red)),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              key: const ValueKey('btnLogin'),
                              icon: const Icon(Icons.login),
                              label: vm.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Ingresar'),
                              onPressed: vm.isLoading
                                  ? null
                                  : () async {
                                      final ok = await vm.login();
                                      if (ok && context.mounted) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) => const PolizaView()),
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
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
