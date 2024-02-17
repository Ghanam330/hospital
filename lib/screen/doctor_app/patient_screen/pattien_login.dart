import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/models/patient/patient_model.dart';
import '../../../constants/constant.dart';
import '../../../cubit/login_cubit/login_in_cubit.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import 'add_Patient.dart';

class PatientLoginScreen extends StatefulWidget {
  PatientLoginScreen({Key? key, required this.section, required this.doctorName})
      : super(key: key);

  String section;
 String doctorName;

  @override
  State<PatientLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<PatientLoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  PatientModel? patientModel;

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
              title: Text(widget.section),
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading:IconButton(
                icon: Icon(Icons.arrow_back), // Replace with the icon you want to show
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [                IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPatientScreen(
                          section: widget.section,
                          doctorName: widget.doctorName,
                        )),
                  );
                },
              ),

              ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Welcome,",
                              fontSize: 30,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: 'Sign in Patient to Continue',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          label: 'Email Patient',
                          prefix: Icons.email,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'email Patient must not be empty';
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email Patient");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          suffix: suffix,
                          isPassword: isPassword,
                          suffixPressed: () {
                            changePasswordVisibility();
                          },
                          type: TextInputType.visiblePassword,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password Patient is too short';
                            }
                            return null;
                          },
                          label: 'Password Patient',
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) {
                              return CustomButton(
                                onPress: () {
                                  if (_globalKey.currentState!.validate()) {
                                    LoginInCubit.get(context).loginPatient(
                                        emailController.text,
                                        passwordController.text,
                                        context,
                                        widget.section,
                                        widget.doctorName
                                    );
                                  } else {
                                    print("errore");
                                  }
                                },
                                text: 'Sign In',
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
}
