import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/constants/colors.dart';
import 'package:hospital/constants/constant.dart';
import 'package:hospital/cubit/patient_cubit/patient_cubit.dart';
import 'package:intl/intl.dart';
import '../../../constants/icon.dart';
import '../../../models/patient/patient_model.dart';
import '../../../widgets/custom_button.dart';

class UpdateUserPatient extends StatefulWidget {
  UpdateUserPatient({Key? key, required this.patientModel}) : super(key: key);
  PatientModel patientModel;

  @override
  State<UpdateUserPatient> createState() => _UpdateUserPatientState();
}

class _UpdateUserPatientState extends State<UpdateUserPatient> {
  DateTime selectedDateTime = DateTime.now();
  String selectedGender = '';

  // Add this variable
  List<String> genderOptions = ['Male', 'Female'];

  // List of gender options
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController data_time_Controller = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController examinationPriceController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      PatientCubit()
        ..getSnapShot(widget.patientModel.id),
      child: BlocBuilder<PatientCubit, PatientState>(
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
            nameController.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .patientName;
            emailController.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .email;
            passwordController.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .password;
            phoneController.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .phoneNumber;
            data_time_Controller.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .appointmentDate;
            ageController.text = PatientCubit
                .get(context)
                .patientModel!
                .age;
            examinationPriceController.text =
                PatientCubit
                    .get(context)
                    .patientModel!
                    .examinationPrice;
            selectedGender = PatientCubit
                .get(context)
                .patientModel!
                .gender;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title:
                const Text('Profile', style: TextStyle(color: kTextColor)),
                backgroundColor: Colors.white,
                elevation: 0.0,
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      PatientCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          appointmentDate: data_time_Controller.text,
                          examinationPrice: examinationPriceController.text,
                          gender: selectedGender,
                          age: ageController.text,
                          // temperature: temperatureController.text,
                          // heartRate: heartRateController.text,
                          // oxygenLevel: oxygenLevelController.text,
                      context: context);
                    },
                    child: const Text(
                      "update",
                      style: TextStyle(color: kPrimaryBlue),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _globalKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (state is HospitalUpdateUserLoadingState)
                          const LinearProgressIndicator(),
                        if (state is HospitalUpdateUserLoadingState)
                          const SizedBox(height: 10.0),
                        SizedBox(
                          height: 150,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: kPrimaryBlue,
                                    radius: 64.0,
                                    child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundColor: kWhiteColor,
                                      backgroundImage: PatientCubit
                                          .get(context)
                                          .profileImage ==
                                          null
                                          ? NetworkImage(PatientCubit
                                          .get(context)
                                          .patientModel!
                                          .imageUrl)
                                          : FileImage(PatientCubit
                                          .get(context)
                                          .profileImage!) as ImageProvider,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        PatientCubit.get(context)
                                            .getProfileImage();
                                      },
                                      icon: const CircleAvatar(
                                        radius: 20.0,
                                        child: Icon(
                                          IconBroken.Camera,
                                          size: 16.0,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        if (PatientCubit
                            .get(context)
                            .profileImage != null)
                          Column(
                            children: [
                              CustomButton(
                                text: 'Click Here To Upload profile Image',
                                onPress: () {
                                  PatientCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      appointmentDate: data_time_Controller.text,
                                      examinationPrice: examinationPriceController.text,
                                      gender: selectedGender,
                                      age: ageController.text,
                                  context: context
                                  );
                                },
                              ),
                              if (state is HospitalUpdateUserLoadingState)
                                const SizedBox(
                                  height: 5,
                                ),
                              if (state is HospitalUpdateUserLoadingState)
                                const LinearProgressIndicator(),
                            ],
                          ),
                        if (PatientCubit
                            .get(context)
                            .profileImage != null)
                          const SizedBox(
                            height: 20.0,
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'email must not be empty';
                            }
                            if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ('Please Enter a valid email');
                            }
                            return null;
                          },
                          label: 'Email',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            } else if (value.length < 11) {
                              return 'please enter your phone number';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
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
                          redOnly: true,
                          onTap: () {
                            showGenderPicker();
                          },
                          controller:
                          TextEditingController(text: selectedGender),
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please select your gender';
                            }
                            return null;
                          },
                          label: 'Gender',
                          prefix: Icons.person,
                          type: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: ageController,
                          type: TextInputType.number,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your age';
                            }
                            return null;
                          },
                          label: 'Age',
                          prefix: Icons.calendar_today,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: examinationPriceController,
                          type: TextInputType.number,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter the examination price';
                            }
                            return null;
                          },
                          label: 'Examination Price',
                          prefix: Icons.attach_money,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // defaultFormField(
                        //   controller: temperatureController,
                        //   type: TextInputType.number,
                        //   validate: (String? value) {
                        //     if (value!.isEmpty) {
                        //       return 'please enter the temperature';
                        //     }
                        //     return null;
                        //   },
                        //   label: 'Temperature',
                        //   prefix: Icons.thermostat,
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // defaultFormField(
                        //   controller: heartRateController,
                        //   type: TextInputType.number,
                        //   validate: (String? value) {
                        //     if (value!.isEmpty) {
                        //       return 'please enter the heart rate';
                        //     }
                        //     return null;
                        //   },
                        //   label: 'Heart Rate',
                        //   prefix: Icons.favorite,
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // defaultFormField(
                        //   controller: oxygenLevelController,
                        //   type: TextInputType.number,
                        //   validate: (String? value) {
                        //     if (value!.isEmpty) {
                        //       return 'please enter the oxygen level';
                        //     }
                        //     return null;
                        //   },
                        //   label: 'Oxygen Level',
                        //   prefix: Icons.local_hospital,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // body: Container(),
            );
          }
        },
      ),
    );
  }


  void showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
