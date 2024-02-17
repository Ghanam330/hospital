import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/cubit/login_cubit/login_in_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../constants/constant.dart';
import '../../../../widgets/custom_text.dart';


class AddPatientScreen extends StatefulWidget {
  AddPatientScreen({Key? key, required this.section, required this.doctorName})
      : super(key: key);

  String section;
String doctorName;

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  DateTime selectedDateTime = DateTime.now();
  String selectedGender = ''; // Add this variable

  List<String> genderOptions = ['Male', 'Female']; // List of gender options

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();
  var data_time_Controller = TextEditingController();
  var ageController = TextEditingController();
  var examinationPriceController = TextEditingController();


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginInCubit(),
      child: BlocConsumer<LoginInCubit, LoginInState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    right: 20,
                    left: 20,
                  ),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        CustomText(
                          text: 'Create Patient Account,',
                          fontSize: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: 'Sign up Patient to Continue',
                          fontSize: 14,
                          color: Colors.grey,
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
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: suffix,
                          onSubmit: (value) {},
                          isPassword: isPassword,
                          suffixPressed: () {
                            changePasswordVisibility();
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
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
                          onTap: () {
                            showGenderPicker();
                          },
                          redOnly: true,
                          controller: TextEditingController(text: selectedGender),
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
                        ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) {
                              return  ElevatedButton(
                                onPressed: ()  {
                                  if (_globalKey.currentState!.validate()) {
                                    LoginInCubit.get(context)
                                        .registerPatient(
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        phoneController.text,
                                        data_time_Controller.text,
                                        examinationPriceController.text,
                                        selectedGender,
                                        ageController.text,
                                        widget.doctorName,
                                        widget.section,
                                        context);
                                  }
                                },
                                child: const Text('Add Patient'),
                              );
                            },
                            fallback: (BuildContext context) => const Center(
                              child: CircularProgressIndicator(),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );

  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    setState(() {});
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
