class VitalSignsModel {
  final String temperature;
  final String heartRate;
  final String oxygenLevel;
  final String appointmentDate;

  VitalSignsModel({
    required this.appointmentDate,
    required this.temperature,
    required this.heartRate,
    required this.oxygenLevel,
  });

  factory VitalSignsModel.fromMap(Map<String, dynamic> map) => VitalSignsModel(
        appointmentDate: map['appointmentDate'],
        temperature: map['temperature'],
        heartRate: map['heartRate'],
        oxygenLevel: map['oxygenLevel'],
      );

  Map<String, dynamic> toMap() {
    return {
      'appointmentDate': appointmentDate,
      'temperature': temperature,
      'heartRate': heartRate,
      'oxygenLevel': oxygenLevel,
    };
  }
}
