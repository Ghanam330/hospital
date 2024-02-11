import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/screen/my_profile/update_doctor_information.dart';
import '../../constants/colors.dart';
import '../../cubit/user_cubit/user_cubit.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   UserCubit.get(context).getSnapShot();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..getSnapShot(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context,state) {
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
            return Scaffold(
              backgroundColor: kPrimaryBlue,
              appBar: AppBar(
                iconTheme: const IconThemeData(
                    color: Colors.white
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UpdateUserDoctor()));
                      // Add your onPressed logic here
                    },
                  ),
                ],
                backgroundColor:kPrimaryBlue,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(
                              top: 30,
                              bottom: 8,
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
                              image:  DecorationImage(
                                image: NetworkImage(UserCubit.get(context).userModel!.image),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
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
                            const SizedBox(height: 16,),
                            listProfile(Icons.person, "Full Name",  UserCubit.get(context)
                                .userModel!.name),
                            listProfile(Icons.email, "Email",  UserCubit.get(context)
                                .userModel!.email),
                            listProfile(Icons.insert_drive_file, "IdCard",  UserCubit.get(context)
                                .userModel!.personId),
                            listProfile(Icons.phone, "Phone Number",  UserCubit.get(context)
                                .userModel!.phone),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );

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
          const SizedBox(width: 24,),
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