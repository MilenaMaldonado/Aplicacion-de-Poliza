import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/poliza_view.dart';
import 'viewmodels/poliza_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PolizaViewModel()),
      ],
      child: MaterialApp(
        title: 'Aplicación de Póliza',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const PolizaView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
