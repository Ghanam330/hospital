import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/constant.dart';
import '../../../../constants/strings.dart';
import '../../../../cubit/login_cubit/login_in_cubit.dart';
import '../../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/option_button.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();
  var idCardController = TextEditingController();

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
              leading: GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, loginScreen, (route) => false),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
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
                          text: 'Create Account,',
                          fontSize: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: 'Sign up to Continue',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: idCardController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your Id number';
                            } else if (value.length < 4) {
                              return 'please enter your PersonId';
                            }
                            return null;
                          },
                          label: 'CardId',
                          prefix: Icons.insert_drive_file,
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
                        CustomButton(
                          onPress: () async {
                            if (_globalKey.currentState!.validate()) {
                              LoginInCubit.get(context).registerDoctor(
                                  idCardController.text,
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  phoneController.text,
                                  context);
                            }
                          },
                          text: 'Sign Up',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OptionButton(
                          desc: 'Already have an account?',
                          method: 'Sign In',
                          onPressHandler: () {
                            Navigator.of(context).pushReplacementNamed(loginScreen);
                          },
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
