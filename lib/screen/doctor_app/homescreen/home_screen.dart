import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital/constants/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/user_cubit/user_cubit.dart';
import '../my_profile/my_profile.dart';
import '../patient_screen/pattien_login.dart';
import '../splach/intro_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var height, width;

  List imageSrc = [
    "assets/images/surgery.json",
    "assets/images/Docotr.json",
    "assets/images/dentist.json",
    "assets/images/Pediatrics.json",
    "assets/images/Dermatology.json",
  ];

  List title = [
    "Surgery",
    "Internal Medicine",
    "Dentist",
    "Pediatrics",
    "Dermatology"
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    // Format the date and time
    String formattedDate = "${now.year}-${now.month}-${now.day}";
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
            String doctorName = UserCubit.get(context).userModel!.name;
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  width: width,
                  color: kPrimaryBlue,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(),
                        height: height * 0.25,
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'item1') {
                                        logout(context);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        const PopupMenuItem<String>(
                                          value: 'item1',
                                          child: Text(
                                            'Sign Out',
                                            style: TextStyle(
                                              color: Colors.blue, // Set the desired text color
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white, // Set the desired icon color
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const ProfileScreen()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15)),
                                      height: 50,
                                      width: 50,
                                      child: SvgPicture.asset(
                                        'assets/images/profile.svg',
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Dashboard",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1),
                                  ),
                                  Text(
                                    "Current Date:$formattedDate",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white54,
                                        letterSpacing: 1),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          width: width,
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              mainAxisSpacing: 25,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientLoginScreen(
                                        doctorName: doctorName,
                                        section: title[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Adjust the width of the Lottie animation based on your needs
                                      Lottie.asset(imageSrc[index],
                                          width: 130, height: 100),
                                      const SizedBox(height: 5),
                                      // Adjust the spacing between the Lottie animation and text
                                      Text(
                                        title[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          // Adjust the font size based on your needs
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        IntroScreen()), (Route<dynamic> route) => false);
  }
}
