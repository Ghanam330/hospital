import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        if (mounted) {
          setState(() => Timer(
            const Duration(seconds: 5),
                () => Navigator.pushNamedAndRemoveUntil(
                context,onboarding, (route) => false),
          ));
        }
      } else {
        if (mounted) {
          setState(() => Timer(
            const Duration(seconds: 5),
                () => Navigator.pushNamedAndRemoveUntil(
                context,homeScreen, (route) => false),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(color: Colors.white),
        child:  Center(
          child: SizedBox(
            width:220,
              height: 220,
              child: Image.asset('assets/images/icon.jpg')
          ),
        ),
      ),
    );
  }
}