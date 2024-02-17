import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/strings.dart';
import '../../patient_app/patientapp_details_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: SizedBox(
              width: 220,
              height: 220,
              child: Image.asset('assets/images/icon.jpg')),
        ),
      ),
    );
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? optionLogin = prefs.getString('option');
    if (userId != null && userId.isNotEmpty) {
      if (optionLogin == 'Doctor') {
        if (mounted) {
          setState(() => Timer(
                const Duration(seconds: 5),
                () => Navigator.pushNamedAndRemoveUntil(
                    context, homeScreen, (route) => false),
              ));
        }
      } else {
        if (mounted) {
          setState(() => Timer(
                const Duration(seconds: 5),
                () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                          PatientAppDetailsScreen()),
                    (Route<dynamic> route) => false),
              ));
        }
      }
    } else {
      if (mounted) {
        setState(() => Timer(
              const Duration(seconds: 5),
              () => Navigator.pushNamedAndRemoveUntil(
                  context, onboarding, (route) => false),
            ));
      }
    }
  }
}
