import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/poliza_model.dart';

class PolizaViewModel extends ChangeNotifier {
  String propietario = '';
  double valorSeguroAuto = 0;
  String modeloAuto = 'A';
  String edadPropietario = '18-23';
  int accidentes = 0;
  double costoTotal = 0;

  final String apiUrl = "http://localhost:9090/bdd_dto/api/poliza";

  void nuevo() {
    propietario = '';
    valorSeguroAuto = 0;
    modeloAuto = 'A';
    edadPropietario = '18-23';
    accidentes = 0;
    costoTotal = 0;
    notifyListeners();
  }

  int _parseEdadPropietario(String edad) {
    switch (edad) {
      case '18-23':
        return 18;
      case '23-55':
        return 24;
      case '55+':
        return 55;
      default:
        return 18;
    }
  }

  Future<void> calcularPoliza() async {
    final poliza = Poliza(
      propietario: propietario,
      modeloAuto: modeloAuto,
      valorSeguroAuto: valorSeguroAuto,
      edadPropietario: _parseEdadPropietario(edadPropietario),
      accidentes: accidentes,
      costoTotal: 0,
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(poliza.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        costoTotal = (data['costoTotal'] as num).toDouble();
        notifyListeners();
      } else {
        costoTotal = 0;
        notifyListeners();
        throw Exception('Error al calcular la póliza: \\n${response.body}');
      }
    } catch (e) {
      costoTotal = 0;
      notifyListeners();
      rethrow;
    }
  }
}
