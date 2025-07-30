import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolizaResumenViewModel extends ChangeNotifier {
  PolizaResumen? poliza;
  bool isLoading = false;
  String? error;

  Future<void> fetchPolizasPorUsuario(String usuario) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9090/bdd_dto/api/poliza/usuario?nombre=$usuario'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        poliza = PolizaResumen.fromJson(data);
      } else {
        error = 'Error al obtener pólizas';
      }
    } catch (e) {
      error = 'Error de conexión';
    }
    isLoading = false;
    notifyListeners();
  }
}

class PolizaResumen {
  final String propietario;
  final String modeloAuto;
  final double valorSeguroAuto;
  final int edadPropietario;
  final int accidentes;
  final double costoTotal;

  PolizaResumen({
    required this.propietario,
    required this.modeloAuto,
    required this.valorSeguroAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory PolizaResumen.fromJson(Map<String, dynamic> json) {
    return PolizaResumen(
      propietario: json['propietario'] ?? '',
      modeloAuto: json['modeloAuto'] ?? '',
      valorSeguroAuto: (json['valorSeguroAuto'] ?? 0).toDouble(),
      edadPropietario: json['edadPropietario'] ?? 0,
      accidentes: json['accidentes'] ?? 0,
      costoTotal: (json['costoTotal'] ?? 0).toDouble(),
    );
  }
}
