import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomTheme {
  final Size screenSize;
  CustomTheme(this.screenSize);

  final double designWidth = 375.0;
  final double designHeight = 812.0;

  double _getProportionateScreenWidth(inputWidth) {
    return (inputWidth / designWidth) * screenSize.width;
  }

  double _getProportionateScreenHeight(inputHeight) {
    return (inputHeight / designHeight) * screenSize.height;
  }


  nunito() => GoogleFonts.nunitoTextTheme(
    TextTheme(
      displayLarge: TextStyle(
        fontSize: _getProportionateScreenWidth(60),
        fontWeight: FontWeight.normal,
        color: kTextColor,
      ),
      displayMedium: TextStyle(
        fontSize: _getProportionateScreenWidth(36),
        fontWeight: FontWeight.normal,
        color: kTextColor,
      ),
      displaySmall: TextStyle(
        fontSize: _getProportionateScreenWidth(24),
        fontWeight: FontWeight.normal,
        color: kTextColor,
      ),
      headlineMedium: const TextStyle().copyWith(
        fontSize: _getProportionateScreenWidth(16),
        fontWeight: FontWeight.normal,
        color: kTextColor,
      ),
      headlineSmall: const TextStyle().copyWith(
        fontSize: _getProportionateScreenWidth(20),
        fontWeight: FontWeight.w700,
        color: kTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: _getProportionateScreenWidth(14),
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontSize: _getProportionateScreenWidth(14),
      ),
    ),
  );

  elevatedButtonTheme() => ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        kPrimaryBlue,
      ),
      foregroundColor: MaterialStateProperty.all(
        Colors.white,
      ),
      elevation: MaterialStateProperty.all(
        0,
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _getProportionateScreenWidth(4),
          ),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          fontSize: _getProportionateScreenWidth(16),
        ),
      ),
      minimumSize: MaterialStateProperty.all(
        Size(
          double.infinity,
          _getProportionateScreenHeight(56),
        ),
      ),
    ),
  );

  outlinedButtonTheme() => OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Colors.white,
      ),
      foregroundColor: MaterialStateProperty.all(
        kPrimaryBlue,
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _getProportionateScreenWidth(4),
          ),
        ),
      ),
      elevation: MaterialStateProperty.all(0),
      side: MaterialStateProperty.all(
        BorderSide(
          width: _getProportionateScreenWidth(
            1.5,
          ),
          color: kPrimaryBlue,
        ),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          fontSize: _getProportionateScreenWidth(
            16,
          ),
        ),
      ),
      minimumSize: MaterialStateProperty.all(
        Size(
          double.infinity,
          _getProportionateScreenHeight(56),
        ),
      ),
    ),
  );

  textButtonTheme() => TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          kPrimaryBlue,
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: _getProportionateScreenWidth(17),
            fontWeight: FontWeight.w600,
          ),
        ),
      ));

  dividerTheme() => const DividerThemeData(
    color: kGreyShade3,
    thickness: 2,
  );
}