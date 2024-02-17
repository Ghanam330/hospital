import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/models/patient/patient_model.dart';
import 'package:hospital/screen/patient_app/patient_cubit_app/patient_cubit_app.dart';
import 'package:hospital/screen/patient_app/update_patientapp_information.dart';
import 'package:hospital/screen/patient_app/vital_sign_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/colors.dart';
import '../doctor_app/splach/intro_screen.dart';

class PatientAppDetailsScreen extends StatelessWidget {
  PatientAppDetailsScreen({Key? key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>PatientAppCubit()..getSnapShotPatientApp(),
      child: BlocBuilder<PatientAppCubit, PatientState>(
        builder: (context, state) {
          if (state is HospitalGetUserLoadingState) {
            return Container(
              color: Colors.white,
              child: AlertDialog(
                content: Builder(builder: (context) {
                  return SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: kPrimaryBlue,
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 7),
                          child: const Text("Loading..."),
                        )
                      ],
                    ),
                  );
                }),
              ),
            );
          } else {
         var   patientModel = PatientAppCubit.get(context).patientModel!;
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
                                  UpdateUserPatientApp(
                                      patientModel: patientModel)));
                      // // Add your onPressed logic here
                    },
                  ),
                ],
                leading: PopupMenuButton<String>(
                  onSelected: (value) {
                    if(value == 'item1') {
                      logout(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'item1',
                        child: Text('Sign Out'),
                      ),
                    ];
                  },
                ),
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
                          bottom:30,
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
                            image: NetworkImage(PatientAppCubit.get(context)
                                .patientModel!
                                .imageUrl),
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
                            Icons.person,
                            "Full Name",
                            PatientAppCubit.get(context)
                                .patientModel!
                                .patientName),
                        listProfile(Icons.email, "Email",
                            PatientAppCubit.get(context).patientModel!.email),
                        listProfile(
                            Icons.event,
                            "Date and Time",
                            PatientAppCubit.get(context)
                                .patientModel!
                                .appointmentDate),
                        listProfile(Icons.person, "Gender",
                            PatientAppCubit.get(context).patientModel!.gender),
                        listProfile(
                            Icons.phone,
                            "Phone Number",
                            PatientAppCubit.get(context)
                                .patientModel!
                                .phoneNumber),
                        listProfile(Icons.calendar_today, "Age",
                            PatientAppCubit.get(context).patientModel!.age),
                        listProfile(
                            Icons.attach_money,
                            "Examination Price",
                            PatientAppCubit.get(context)
                                .patientModel!
                                .examinationPrice),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        VitalSignsAppScreen()));
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
        },
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    IntroScreen()), (Route<dynamic> route) => false);
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
