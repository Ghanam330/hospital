import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital/screen/patient_app/patient_cubit_app/patient_cubit_app.dart';
import 'package:hospital/screen/patient_app/vitalsigns_details.dart';
import '../../../../constants/colors.dart';
import '../../../../models/patient/vital_signs_model.dart';

class VitalSignsAppScreen extends StatelessWidget {
  const VitalSignsAppScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientAppCubit()..getVitalSigns(),
      child: BlocBuilder<PatientAppCubit, PatientState>(
        builder: (context, state) {
          if (state is VitalSignsLoadingState) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('VitalSigns',
                    style: TextStyle(color: kTextColor)),
                backgroundColor: Colors.white,
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
            if (PatientAppCubit.get(context).vitalSignsList.isNotEmpty) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('VitalSigns',
                      style: TextStyle(color: kTextColor)),
                  backgroundColor: Colors.white,
                ),
                body: ListView.builder(
                  itemCount: PatientAppCubit.get(context).vitalSignsList.length,
                  itemBuilder: (context, index) {
                    VitalSignsModel vitalSigns =
                    PatientAppCubit.get(context).vitalSignsList[index];
                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.local_hospital),
                            title: Text(vitalSigns.appointmentDate),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VitalSignsDetails(vitalSignsModel: vitalSigns,)),
                              );
                            },
                            // subtitle: Text(
                            //     'Temperature: ${vitalSigns.temperature}\nOxygen Level: ${vitalSigns.oxygenLevel}\nAppointment Date: ${vitalSigns.appointmentDate}'),
                          ),
                          const Divider(),
                        ],
                      ),
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
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw a line from top-left to bottom-right
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
