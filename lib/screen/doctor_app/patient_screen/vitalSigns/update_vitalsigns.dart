import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/constants/colors.dart';
import 'package:hospital/constants/constant.dart';
import 'package:hospital/cubit/patient_cubit/patient_cubit.dart';
import 'package:hospital/models/patient/vital_signs_model.dart';
import 'package:intl/intl.dart';



class UpdateVitalSigns extends StatelessWidget {
  UpdateVitalSigns({Key? key,required this.vitalSignsModel}) : super(key: key);

  VitalSignsModel vitalSignsModel;


  DateTime selectedDateTime = DateTime.now();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController oxygenLevelController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController data_time_Controller = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    temperatureController.text = vitalSignsModel.temperature;
    oxygenLevelController.text =vitalSignsModel.oxygenLevel;
    heartRateController.text =vitalSignsModel.heartRate;
    data_time_Controller.text =vitalSignsModel.appointmentDate;
    return BlocProvider(
      create: (context) =>
          PatientCubit(),
      child: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(vitalSignsModel.appointmentDate, style: TextStyle(color: kTextColor)),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        onTap: () async {
                          DateTime? pickedDateTime = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDateTime != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              selectedDateTime = DateTime(
                                pickedDateTime.year,
                                pickedDateTime.month,
                                pickedDateTime.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );

                              // Format the selectedDateTime to display in the TextFormField
                              String formattedDateTime =
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(selectedDateTime);

                              data_time_Controller.text = formattedDateTime;
                            }
                          }
                        },
                        redOnly: true,
                        controller: data_time_Controller,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'please select a date and time';
                          }
                          return null;
                        },
                        label: 'Date and Time',
                        prefix: Icons.event,
                        type: TextInputType.datetime,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: temperatureController,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter the temperature';
                          }
                          return null;
                        },
                        label: 'Temperature',
                        prefix: Icons.thermostat,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: heartRateController,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter the heart rate';
                          }
                          return null;
                        },
                        label: 'Heart Rate',
                        prefix: Icons.favorite,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: oxygenLevelController,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter the oxygen level';
                          }
                          return null;
                        },
                        label: 'Oxygen Level',
                        prefix: Icons.local_hospital,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                          condition: state is! VitalSignsLoadingState,
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_globalKey.currentState!.validate()) {
                                  PatientCubit.get(context).updateVitalSigns(
                                     temperatureController.text,
                                      heartRateController.text,
                                      oxygenLevelController.text,
                                      data_time_Controller.text, context);
                                }
                              },
                              child: const Text('Update VitalSigns'),
                            );
                          },
                          fallback: (BuildContext context) =>
                          const Center(
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            // body: Container(),
          );
        },
      ),
    );
  }

}
