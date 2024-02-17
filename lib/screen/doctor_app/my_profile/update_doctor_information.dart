import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/constants/colors.dart';
import 'package:hospital/constants/constant.dart';
import '../../../constants/icon.dart';
import '../../../cubit/user_cubit/user_cubit.dart';
import '../../../widgets/custom_button.dart';



class UpdateUserDoctor extends StatelessWidget {
  UpdateUserDoctor({Key? key}) : super(key: key);
  TextEditingController idCardController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..getSnapShot(),
      child: BlocBuilder<UserCubit, UserState>(
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
            idCardController.text = UserCubit.get(context).userModel!.personId;
            nameController.text = UserCubit.get(context).userModel!.name;
            phoneController.text = UserCubit.get(context).userModel!.phone;
            emailController.text = UserCubit.get(context).userModel!.email;
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
                      UserCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          personId: idCardController.text,context: context);
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
                                      backgroundImage: UserCubit.get(context)
                                                  .profileImage ==
                                              null
                                          ? NetworkImage(UserCubit.get(context)
                                              .userModel!
                                              .image)
                                          : FileImage(UserCubit.get(context)
                                              .profileImage!) as ImageProvider,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        UserCubit.get(context)
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
                        if (UserCubit.get(context).profileImage != null)
                          Column(
                            children: [
                              CustomButton(
                                text: 'Click Here To Upload profile Image',
                                onPress: () {
                                  UserCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    personId: idCardController.text,
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
                        if (UserCubit.get(context).profileImage != null)
                          const SizedBox(
                            height: 20.0,
                          ),
                        defaultFormField(
                          controller: idCardController,
                          type: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your PersonId';
                            } else if (value.length < 4) {
                              return 'please enter your PersonId';
                            }
                            return null;
                          },
                          label: 'CardId',
                          prefix: Icons.insert_drive_file,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'name must not be empty';
                            }
                            return null;
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            } else if (value.length < 11) {
                              return 'too short for a phone number!';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
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
}
