import 'package:flutter/material.dart';
import 'package:front_poliza/models/poliza_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//clase para cambiar de estado las poliza
class PolizaViewModel extends ChangeNotifier {
  //variables
  String propietario = '';
  double valor = 0.0;
  String modeloAuto = 'A';
  String edadPropietario = '18-23';
  int accidentes = 0;
  double costoTotal = 0.0;

  // URL de la API
  final String apiUrl = 'http://localhost:9090/api/polizas';

  void nuevo(){
    propietario = '';
    valor = 0.0;
    modeloAuto = 'A';
    edadPropietario = '18-23';
    accidentes = 0;
    costoTotal = 0.0;
    notifyListeners();
  }

  // Metodo para calcular el costo de la póliza
  Future<void> calcularPoliza() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'propietario': propietario,
        'valor': valor,
        'modeloAuto': modeloAuto,
        'edadPropietario': edadPropietario,
        'accidentes': accidentes,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      costoTotal = data['costoTotal'];
      notifyListeners();
    } else {
      throw Exception('No se calculo el costo');
    }
  }


  //a partir de aqui hizo chat, mejorar
  //lista de uuarios

  List<Poliza> _polizas = [];
  bool _isLoading = false;

  List<Poliza> get polizas => _polizas;
  bool get isLoading => _isLoading;

  Future<void> fetchPolizas() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('http://localhost:9090/polizas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _polizas = data.map((json) => Poliza.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load polizas');
    }

    _isLoading = false;
    notifyListeners();
  }
}