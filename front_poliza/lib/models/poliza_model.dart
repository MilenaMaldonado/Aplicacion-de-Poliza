class Poliza {
  final String propietario;
  final String modeloAuto;
  final double valorSeguroAuto;
  final int edadPropietario;
  final int accidentes;
  final double costoTotal;

  Poliza({
    required this.propietario,
    required this.modeloAuto,
    required this.valorSeguroAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(
      propietario: json['propietario'] as String,
      modeloAuto: json['modeloAuto'] as String,
      valorSeguroAuto: (json['valorSeguroAuto'] as num).toDouble(),
      edadPropietario: json['edadPropietario'] as int,
      accidentes: json['accidentes'] as int,
      costoTotal: (json['costoTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propietario': propietario,
      'modeloAuto': modeloAuto,
      'valorSeguroAuto': valorSeguroAuto,
      'edadPropietario': edadPropietario,
      'accidentes': accidentes,
    };
  }
}
