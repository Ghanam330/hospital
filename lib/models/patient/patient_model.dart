class PatientModel {
  final String id;
  final String patientName; // Added field for patient name
  final String phoneNumber;
  final String email; // Added field for email
  final String password; // Added field for password
  final String appointmentDate;
  final String examinationPrice;
  final String gender;
  final String age;
  final String doctorName;
  final String registeredSection;
  final String imageUrl; // Added field for image URL

  PatientModel({
    required this.id,
    required this.patientName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.appointmentDate,
    required this.examinationPrice,
    required this.gender,
    required this.age,
    required this.doctorName,
    required this.registeredSection,
    required this.imageUrl,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) =>
   PatientModel(
      id: map['id'],
      patientName: map['patientName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      password: map['password'],
      appointmentDate: map['appointmentDate'],
      examinationPrice: map['examinationPrice'],
      gender: map['gender'],
      age: map['age'],
      doctorName: map['doctorName'],
      registeredSection: map['registeredSection'],
      imageUrl: map['imageUrl'],
    );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'appointmentDate': appointmentDate,
      'examinationPrice': examinationPrice,
      'gender': gender,
      'age': age,
      'doctorName': doctorName,
      'registeredSection': registeredSection,
      'imageUrl': imageUrl,
    };
  }
}
