import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital/screen/doctor_app/patient_screen/vitalSigns/add_vitalsigns.dart';
import 'package:hospital/screen/doctor_app/patient_screen/vitalSigns/update_vitalsigns.dart';
import '../../../../constants/colors.dart';
import '../../../../cubit/patient_cubit/patient_cubit.dart';
import '../../../../models/patient/patient_model.dart';
import '../../../../models/patient/vital_signs_model.dart';

class VitalSignsScreen extends StatelessWidget {
  VitalSignsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientCubit()..getVitalSigns(),
      child: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          if (state is VitalSignsLoadingState) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('VitalSigns',
                    style: TextStyle(color: kTextColor)),
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddVitalSigns()),
                      );
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: SvgPicture.asset(
                          'assets/images/empty.svg',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (PatientCubit.get(context).vitalSignsList.isNotEmpty) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('VitalSigns',
                      style: TextStyle(color: kTextColor)),
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddVitalSigns()),
                        );
                      },
                    ),
                  ],
                ),
                body: ListView.builder(
                  itemCount: PatientCubit.get(context).vitalSignsList.length,
                  itemBuilder: (context, index) {
                    VitalSignsModel vitalSigns =
                        PatientCubit.get(context).vitalSignsList[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.local_hospital),
                          title: Text(vitalSigns.appointmentDate),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateVitalSigns(vitalSignsModel: vitalSigns,)),
                            );
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('VitalSigns',
                      style: TextStyle(color: kTextColor)),
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddVitalSigns()),
                  );
                },
              ),
          ],
          ),
                body: Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/empty.svg',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
