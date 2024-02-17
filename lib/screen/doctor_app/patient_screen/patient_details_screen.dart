import 'package:flutter/material.dart';
import 'package:hospital/screen/doctor_app/patient_screen/update_patient_information.dart';
import 'package:hospital/screen/doctor_app/patient_screen/vitalSigns/vital_sign_screen.dart';

import '../../../constants/colors.dart';
import '../../../models/patient/patient_model.dart';

class PatientDetailsScreen extends StatelessWidget {
  PatientModel patientModel;

  PatientDetailsScreen({required this.patientModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBlue,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UpdateUserPatient(patientModel: patientModel)));
              // // Add your onPressed logic here
            },
          ),
        ],
        backgroundColor: kPrimaryBlue,
      ),
      body: ListView(
        children: [
          // Profile Picture Section
          Column(
            children: [
              Container(
                height: 120,
                width: 120,
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 10,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(patientModel.imageUrl),
                  ),
                ),
              ),
            ],
          ),
          // Profile Information Section
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "PROFILE",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // Profile Details
                listProfile(
                    Icons.person, "Full Name", patientModel.patientName),
                listProfile(Icons.email, "Email", patientModel.email),
                listProfile(
                    Icons.event, "Date and Time", patientModel.appointmentDate),
                listProfile(Icons.person, "Gender", patientModel.gender),
                listProfile(
                    Icons.phone, "Phone Number", patientModel.phoneNumber),
                listProfile(Icons.calendar_today, "Age", patientModel.age),
                listProfile(Icons.attach_money, "Examination Price",
                    patientModel.examinationPrice),
                // listProfile(
                //     Icons.thermostat, "Temperature", patientModel.temperature),
                // listProfile(
                //     Icons.favorite, "Heart Rate", patientModel.heartRate),
                // listProfile(Icons.local_hospital, "Oxygen Level",
                //     patientModel.oxygenLevel),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                VitalSignsScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_hospital,
                          size: 20,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'Vital Signs',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Montserrat",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
