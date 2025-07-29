import 'dart:math';

class Poliza {
  final String propietario;
  final double valor;
  final String modeloAuto;
  final String edadPropietario;
  final int accidentes;
  final double costoTotal;

  Poliza(
     {
        required this.propietario,
        required this.valor,
        required this.modeloAuto,
        required this.edadPropietario,
        required this.accidentes,
       required this.costoTotal
     });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(

      propietario: json['propietario'] as String,
      valor: (json['valor'] as num).toDouble(),
      modeloAuto: json['modeloAuto'] as String,
      edadPropietario: json['edadPropietario'] as String,
      accidentes: json['accidentes'] as int,
      costoTotal: json['costoTotal'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propietario': propietario,
      'valor': valor,
      'modeloAuto': modeloAuto,
      'edadPropietario': edadPropietario,
      'accidentes': accidentes,
      'costoTotal': costoTotal,
    };
  }
}
