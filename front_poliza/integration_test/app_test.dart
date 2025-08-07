import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:front_poliza/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de integración de la app de pólizas', () {
    testWidgets('1. Login correcto', (WidgetTester tester) async {
      // Objetivo: Verificar el flujo de login exitoso
      app.main();
      await tester.pumpAndSettle();

      // Ingresa credenciales válidas
      await tester.enterText(find.byKey(const ValueKey('txtUsuario')), 'admin');
      await tester.enterText(find.byKey(const ValueKey('txtPassword')), 'admin');

      // Pulsa el botón de login
      await tester.tap(find.byKey(const ValueKey('btnLogin')));
      await tester.pumpAndSettle();

      // Verifica que se navegó a la pantalla de registro de póliza
      expect(find.text('Registrar Póliza'), findsOneWidget);
    });

    testWidgets('2. Login incorrecto', (WidgetTester tester) async {
      // Objetivo: Validar rechazo de credenciales incorrectas
      app.main();
      await tester.pumpAndSettle();

      // Ingresa credenciales inválidas
      await tester.enterText(find.byKey(const ValueKey('txtUsuario')), 'invalid');
      await tester.enterText(find.byKey(const ValueKey('txtPassword')), 'wrong');

      // Pulsa el botón de login
      await tester.tap(find.byKey(const ValueKey('btnLogin')));
      await tester.pumpAndSettle();

      // Verifica que se muestra el mensaje de error
      expect(find.text('Credenciales incorrectas'), findsOneWidget);
    });

    testWidgets('3. Registro y cálculo de póliza', (WidgetTester tester) async {
      // Objetivo: Validar el flujo completo de registro y cálculo
      app.main();
      await tester.pumpAndSettle();

      // Login primero
      await tester.enterText(find.byKey(const ValueKey('txtUsuario')), 'admin');
      await tester.enterText(find.byKey(const ValueKey('txtPassword')), 'admin');
      await tester.tap(find.byKey(const ValueKey('btnLogin')));
      await tester.pumpAndSettle();

      // Ingresa datos de la póliza
      await tester.enterText(find.byKey(const ValueKey('txtPropietario')), 'Juan Pérez');
      await tester.enterText(find.byKey(const ValueKey('txtValorSeguro')), '10000');

      // Selecciona modelo A
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      // Selecciona rango de edad
      await tester.tap(find.text('Mayor igual a 18 y menor a 23'));
      await tester.pumpAndSettle();

      // Ingresa número de accidentes
      await tester.enterText(find.byKey(const ValueKey('txtAccidentes')), '2');

      // Calcula la póliza
      await tester.tap(find.byKey(const ValueKey('btnCalcularPoliza')));
      await tester.pumpAndSettle();

      // Verifica que se muestra el costo total
      expect(find.textContaining('Costo total:'), findsOneWidget);
    });

    testWidgets('4. Consulta de usuarios registrados', (WidgetTester tester) async {
      // Objetivo: Verificar la lista de usuarios
      app.main();
      await tester.pumpAndSettle();

      // Login primero
      await tester.enterText(find.byKey(const ValueKey('txtUsuario')), 'admin');
      await tester.enterText(find.byKey(const ValueKey('txtPassword')), 'admin');
      await tester.tap(find.byKey(const ValueKey('btnLogin')));
      await tester.pumpAndSettle();

      // Navega a la vista de usuarios
      await tester.tap(find.byIcon(Icons.people));
      await tester.pumpAndSettle();

      // Verifica que estamos en la vista de usuarios
      expect(find.text('Lista de Usuarios'), findsOneWidget);

      // Verifica que se muestra al menos un usuario
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('5. Visualización de resumen de póliza', (WidgetTester tester) async {
      // Objetivo: Verificar el resumen de una póliza
      app.main();
      await tester.pumpAndSettle();

      // Login primero
      await tester.enterText(find.byKey(const ValueKey('txtUsuario')), 'admin');
      await tester.enterText(find.byKey(const ValueKey('txtPassword')), 'admin');
      await tester.tap(find.byKey(const ValueKey('btnLogin')));
      await tester.pumpAndSettle();

      // Ingresa un propietario
      await tester.enterText(find.byKey(const ValueKey('txtPropietario')), 'Juan Pérez');

      // Navega al resumen
      await tester.tap(find.byIcon(Icons.summarize));
      await tester.pumpAndSettle();

      // Verifica que estamos en la vista de resumen
      expect(find.text('Resumen de Pólizas'), findsOneWidget);
    });
  });
}
