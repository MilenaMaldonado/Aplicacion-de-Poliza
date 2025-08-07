import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginViewModel extends ChangeNotifier {
  String usuario = '';
  String password = '';
  bool isLoading = false;
  String? error;

  final String apiUrl = "http://10.0.2.2:9090/bdd_dto/api/login";

  Future<bool> login() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'usuario': usuario,
          'password': password,
        }),
      );
      isLoading = false;
      if (response.statusCode == 200) {
        return true;
      } else {
        error = 'Credenciales incorrectas';
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      error = 'Error de conexión';
      notifyListeners();
      return false;
    }
  }
}
