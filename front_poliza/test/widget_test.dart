// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_poliza/views/login_view.dart';
import 'package:front_poliza/views/usuarios_view.dart';
import 'package:front_poliza/views/poliza_view.dart';
import 'package:provider/provider.dart';
import 'package:front_poliza/viewmodels/login_viewmodel.dart';
import 'package:front_poliza/viewmodels/usuarios_viewmodel.dart';
import 'package:front_poliza/viewmodels/poliza_viewmodel.dart';

// Mock ViewModel para pruebas
class MockLoginViewModel extends LoginViewModel {
  @override
  Future<bool> login() async {
    return true;
  }
}

class MockUsuariosViewModel extends UsuariosViewModel {
  @override
  Future<void> fetchUsuarios() async {
    // Simula datos de prueba
    usuarios = [
      Usuario(id: 1, nombreCompleto: "Juan Pérez", edad: 25, automovilIds: [1]),
      Usuario(id: 2, nombreCompleto: "Ana López", edad: 30, automovilIds: [2, 3])
    ];
    notifyListeners();
  }
}

class MockPolizaViewModel extends PolizaViewModel {
  @override
  Future<void> calcularPoliza() async {
    // Simula el cálculo de una póliza
    costoTotal = 1500.0;
    notifyListeners();
  }
}

void main() {
  group('Pruebas de widgets de la aplicación', () {
    testWidgets('Login view muestra campos requeridos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => MockLoginViewModel(),
            child: const LoginView(),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('txtUsuario')), findsOneWidget);
      expect(find.byKey(const ValueKey('txtPassword')), findsOneWidget);
      expect(find.byKey(const ValueKey('btnLogin')), findsOneWidget);
    });

    testWidgets('Usuarios view muestra lista y botones', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => MockUsuariosViewModel(),
            child: const UsuariosView(),
          ),
        ),
      );

      // Espera a que se complete la animación y la carga
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('refreshButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('menuButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('backButton')), findsOneWidget);
    });

    testWidgets('Poliza view muestra formulario', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PolizaViewModel(),
            child: const PolizaView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('txtPropietario')), findsOneWidget);
      expect(find.byKey(const ValueKey('txtValorSeguro')), findsOneWidget);
      expect(find.byKey(const ValueKey('txtAccidentes')), findsOneWidget);
      expect(find.byKey(const ValueKey('btnCalcularPoliza')), findsOneWidget);
    });

    testWidgets('Campos de póliza aceptan entrada de datos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PolizaViewModel(),
            child: const PolizaView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('txtPropietario')), 'Juan Pérez');
      await tester.enterText(find.byKey(const ValueKey('txtValorSeguro')), '10000');
      await tester.enterText(find.byKey(const ValueKey('txtAccidentes')), '2');

      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('10000'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
