import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuariosViewModel extends ChangeNotifier {
  List<Usuario> usuarios = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchUsuarios() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9090/bdd_dto/api/propietarios'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        usuarios = data.map((e) => Usuario.fromJson(e)).toList();
      } else {
        error = 'Error al obtener usuarios';
      }
    } catch (e) {
      error = 'Error de conexión';
    }
    isLoading = false;
    notifyListeners();
  }
}

class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}
