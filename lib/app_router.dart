import 'package:flutter/material.dart';
import 'package:hospital/screen/doctor_app/auth_ui/change_password/change_password.dart';
import 'package:hospital/screen/doctor_app/auth_ui/login/login_screen.dart';
import 'package:hospital/screen/doctor_app/auth_ui/sign_up/signup_screen.dart';
import 'package:hospital/screen/doctor_app/homescreen/home_screen.dart';
import 'package:hospital/screen/doctor_app/splach/intro_screen.dart';
import 'package:hospital/screen/doctor_app/splach/splash_screen.dart';
import 'constants/strings.dart';



class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
     case resetPasswordScreen:
       return MaterialPageRoute(builder: (_) => PasswordResetScreen());
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen()
        );


    }
  }
}

