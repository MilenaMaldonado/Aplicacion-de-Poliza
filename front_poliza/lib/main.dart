import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/poliza_view.dart';
import 'viewmodels/poliza_viewmodel.dart';
import 'views/login_view.dart';

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
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF1565C0), // Azul seguro
            onPrimary: Colors.white,
            secondary: Color(0xFF43A047), // Verde confianza
            onSecondary: Colors.white,
            error: Color(0xFFD32F2F),
            onError: Colors.white,
            background: Color(0xFFF5F7FA),
            onBackground: Color(0xFF222B45),
            surface: Colors.white,
            onSurface: Color(0xFF222B45),
          ),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            bodyMedium: TextStyle(fontSize: 16),
            labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF43A047),
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const LoginView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
