import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/constant.dart';
import '../../../../constants/strings.dart';
import '../../../../cubit/login_cubit/login_in_cubit.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/option_button.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  IconData suffix = Icons.visibility_outlined;
  QuerySnapshot? querySnapshot;
  bool isPassword = true;
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginInCubit(),
      child: BlocConsumer<LoginInCubit, LoginInState>(
        listener: (context, state) {
        },
        builder: (context, state) {
       return   Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
                          text: "Welcome To",
                          fontSize: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: 'Sign in to Continue',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          label: 'Email',
                          prefix: Icons.email,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'email must not be empty';
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 'Doctor',
                                  groupValue: selectedUserType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedUserType = value!;
                                    });
                                  },
                                  activeColor: kPrimaryBlue,
                                ),
                                const Text('Doctor'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'Patient',
                                  groupValue: selectedUserType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedUserType = value!;
                                    });
                                  },
                                  activeColor: kPrimaryBlue,
                                ),
                                const Text('Patient'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          onTap: () {
                            Navigator.pushNamed(
                                context, resetPasswordScreen);
                          },
                          text: 'Reset Password?',
                          fontSize: 16,
                          alignment: Alignment.topRight,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) {
                              return CustomButton(
                                onPress: () async {
                                  if (_globalKey.currentState!.validate()&&
                                      selectedUserType != null) {
                                    if (selectedUserType == 'Doctor') {
                                      LoginInCubit.get(context).loginAppDoctor(
                                          emailController.text,
                                          passwordController.text,
                                          context);
                                    } else {
                                      LoginInCubit.get(context).loginAppPatient(
                                          emailController.text,
                                          passwordController.text,
                                          context,
                                      );
                                    }
                                  } else {
                                    showMessage("select Option",context);
                                  }
                                },
                                text: 'Sign In',
                              );
                            },
                            fallback: (BuildContext context) => const Center(
                              child: CircularProgressIndicator(),
                            )),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     if (_globalKey.currentState!.validate() &&
                        //         selectedUserType != null) {
                        //       bool isLogin =false;
                        //       if (selectedUserType == 'Doctor') {
                        //         isLogin = await FirebaseAuthHelper().loginDoctor(
                        //             emailController.text,
                        //             passwordController.text,
                        //             context);
                        //         saveOptionLogin('Doctor');
                        //       } else {
                        //         // isLogin = await FirebaseAuthHelper().loginPatient(
                        //         //     emailController.text,
                        //         //     passwordController.text,
                        //         //     context);
                        //         saveOptionLogin('Patient');
                        //       }
                        //       if (isLogin) {
                        //         _navigateToUserScreen();
                        //       }
                        //     } else {
                        //       showMessage("select Option",context);
                        //     }
                        //   },
                        //   child: const Text('Sign In'),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        OptionButton(
                          desc: "Don't have an account?",
                          method: 'Sign Up',
                          onPressHandler: () {
                            Navigator.of(context).pushReplacementNamed(signupScreen);
                          },
                        ),
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
